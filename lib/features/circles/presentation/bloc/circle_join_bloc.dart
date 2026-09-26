import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/get_circle_package_usecase.dart';
import '../../domain/usecases/submit_circle_join_usecase.dart';
import 'circle_join_event.dart';
import 'circle_join_state.dart';

class CircleJoinBloc extends Bloc<CircleJoinEvent, CircleJoinState> {
  final SubmitCircleJoinUseCase submitCircleJoinUseCase;
  final GetCirclePackageUseCase? getCirclePackageUseCase;

  CircleJoinBloc({
    required this.submitCircleJoinUseCase,
    this.getCirclePackageUseCase,
    CircleCategoryEntity? initialCategory,
    bool initialIsOther = false,
  }) : super(CircleJoinState(
          selectedSubcategory: initialCategory,
          isOtherSelected: initialIsOther,
        )) {
    on<CircleJoinSubcategoryUpdated>(_onSubcategoryUpdated);
    on<CircleJoinPackageRequested>(_onPackageRequested);
    on<CircleJoinSubmitted>(_onJoinSubmitted);
  }

  void _onSubcategoryUpdated(
    CircleJoinSubcategoryUpdated event,
    Emitter<CircleJoinState> emit,
  ) {
    emit(state.copyWith(
      selectedSubcategory: event.subcategory,
      isOtherSelected: event.isOther,
      clearSelected: event.isOther,
    ));
  }

  Future<void> _onPackageRequested(
    CircleJoinPackageRequested event,
    Emitter<CircleJoinState> emit,
  ) async {
    if (getCirclePackageUseCase == null) return;
    emit(state.copyWith(isPackageLoading: true));
    try {
      final packageInfo = await getCirclePackageUseCase!(event.circleId);
      emit(state.copyWith(
        isPackageLoading: false,
        packageInfo: packageInfo,
      ));
    } catch (_) {
      emit(state.copyWith(isPackageLoading: false));
    }
  }

  Future<void> _onJoinSubmitted(
    CircleJoinSubmitted event,
    Emitter<CircleJoinState> emit,
  ) async {
    emit(state.copyWith(status: CircleJoinStatus.submitting));
    try {
      final req = await submitCircleJoinUseCase(
        circleId: event.circleId,
        reason: event.reason,
        categoryId: event.defaultSectorId ?? state.selectedSubcategory?.id,
        level4CategoryId:
            state.isOtherSelected ? null : state.selectedSubcategory?.id,
        isOtherCategory: state.isOtherSelected,
        customCategoryName: event.customCategoryName,
      );

      emit(state.copyWith(
        status: CircleJoinStatus.success,
        submittedRequest: req,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CircleJoinStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
