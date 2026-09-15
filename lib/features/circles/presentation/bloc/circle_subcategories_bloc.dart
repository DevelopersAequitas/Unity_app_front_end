import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/get_category_subcategories_usecase.dart';
import 'circle_subcategories_event.dart';
import 'circle_subcategories_state.dart';

class CircleSubcategoriesBloc
    extends Bloc<CircleSubcategoriesEvent, CircleSubcategoriesState> {
  final GetCategorySubcategoriesUseCase getCategorySubcategoriesUseCase;

  CircleSubcategoriesBloc({
    required this.getCategorySubcategoriesUseCase,
    CircleCategoryEntity? initialSelectedCategory,
    bool initialIsOther = false,
  }) : super(CircleSubcategoriesState(
          selectedSubcategory: initialSelectedCategory,
          isOtherSelected: initialIsOther,
        )) {
    on<CircleSubcategoriesFetchRequested>(_onFetchRequested);
    on<CircleSubcategoriesSearchChanged>(_onSearchChanged);
    on<CircleSubcategorySelected>(_onSubcategorySelected);
  }

  Future<void> _onFetchRequested(
    CircleSubcategoriesFetchRequested event,
    Emitter<CircleSubcategoriesState> emit,
  ) async {
    emit(state.copyWith(status: CircleSubcategoriesStatus.loading));
    try {
      final cats = await getCategorySubcategoriesUseCase(event.circleId);
      final selected = state.selectedSubcategory;
      CircleCategoryEntity? matchedSelected = selected;
      if (selected != null && !state.isOtherSelected) {
        final found = cats.where((c) {
          if (c.id.isNotEmpty && selected.id.isNotEmpty) {
            return c.id.toString() == selected.id.toString();
          }
          return c.name.trim().toLowerCase() ==
              selected.name.trim().toLowerCase();
        }).firstOrNull;
        if (found != null) {
          matchedSelected = found;
        }
      }

      emit(state.copyWith(
        status: CircleSubcategoriesStatus.success,
        allSubcategories: cats,
        filteredSubcategories: _filterList(cats, state.searchQuery),
        selectedSubcategory: matchedSelected,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CircleSubcategoriesStatus.error,
        errorMessage: 'Failed to load specializations. Please try again.',
      ));
    }
  }

  void _onSearchChanged(
    CircleSubcategoriesSearchChanged event,
    Emitter<CircleSubcategoriesState> emit,
  ) {
    final query = event.query;
    final filtered = _filterList(state.allSubcategories, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredSubcategories: filtered,
    ));
  }

  void _onSubcategorySelected(
    CircleSubcategorySelected event,
    Emitter<CircleSubcategoriesState> emit,
  ) {
    emit(state.copyWith(
      selectedSubcategory: event.subcategory,
      isOtherSelected: event.isOther,
      clearSelected: event.isOther,
    ));
  }

  List<CircleCategoryEntity> _filterList(
    List<CircleCategoryEntity> source,
    String query,
  ) {
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return source;
    return source.where((cat) {
      return cat.name.toLowerCase().contains(lower) ||
          (cat.slug != null && cat.slug!.toLowerCase().contains(lower));
    }).toList();
  }
}
