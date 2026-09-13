import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_cached_circles_usecase.dart';
import '../../domain/usecases/get_circle_categories_usecase.dart';
import '../../domain/usecases/get_circle_detail_usecase.dart';
import '../../domain/usecases/get_my_circles_usecase.dart';
import 'circles_event.dart';
import 'circles_state.dart';

class CirclesBloc extends Bloc<CirclesEvent, CirclesState> {
  final GetMyCirclesUseCase getMyCirclesUseCase;
  final GetCircleCategoriesUseCase getCircleCategoriesUseCase;
  final GetCircleDetailUseCase getCircleDetailUseCase;
  final GetCachedCirclesUseCase getCachedCirclesUseCase;

  CirclesBloc({
    required this.getMyCirclesUseCase,
    required this.getCircleCategoriesUseCase,
    required this.getCircleDetailUseCase,
    required this.getCachedCirclesUseCase,
  }) : super(const CirclesState()) {
    on<CirclesFetchRequested>(_onFetchRequested);
    on<CirclesRefreshRequested>(_onRefreshRequested);
    on<CirclesTabChanged>(_onTabChanged);
    on<CirclesSearchChanged>(_onSearchChanged);
    on<CircleDetailRequested>(_onDetailRequested);
  }

  Future<void> _onFetchRequested(
    CirclesFetchRequested event,
    Emitter<CirclesState> emit,
  ) async {
    // Load cache first if available
    final cachedCircles = await getCachedCirclesUseCase.getMyCircles();
    final cachedCategories = await getCachedCirclesUseCase.getCategories();
    if (cachedCircles.isNotEmpty || cachedCategories.isNotEmpty) {
      emit(state.copyWith(
        status: CirclesStatus.success,
        myCircles: cachedCircles.isNotEmpty ? cachedCircles : state.myCircles,
        categories: cachedCategories.isNotEmpty ? cachedCategories : state.categories,
      ));
    } else {
      emit(state.copyWith(status: CirclesStatus.loading));
    }

    try {
      final results = await Future.wait([
        getMyCirclesUseCase(),
        getCircleCategoriesUseCase(),
      ]);
      emit(state.copyWith(
        status: CirclesStatus.success,
        myCircles: results[0] as dynamic,
        categories: results[1] as dynamic,
        clearError: true,
      ));
    } catch (e) {
      if (state.myCircles.isEmpty && state.categories.isEmpty) {
        emit(state.copyWith(
          status: CirclesStatus.error,
          errorMessage: e.toString().replaceAll('Exception:', '').trim(),
        ));
      }
    }
  }

  Future<void> _onRefreshRequested(
    CirclesRefreshRequested event,
    Emitter<CirclesState> emit,
  ) async {
    try {
      final results = await Future.wait([
        getMyCirclesUseCase(),
        getCircleCategoriesUseCase(),
      ]);
      emit(state.copyWith(
        status: CirclesStatus.success,
        myCircles: results[0] as dynamic,
        categories: results[1] as dynamic,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }

  void _onTabChanged(CirclesTabChanged event, Emitter<CirclesState> emit) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }

  void _onSearchChanged(CirclesSearchChanged event, Emitter<CirclesState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onDetailRequested(
    CircleDetailRequested event,
    Emitter<CirclesState> emit,
  ) async {
    try {
      final detail = await getCircleDetailUseCase(event.circleId);
      emit(state.copyWith(selectedCircle: detail));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }
}
