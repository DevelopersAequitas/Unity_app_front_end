import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';

enum CircleSubcategoriesStatus { initial, loading, success, error }

class CircleSubcategoriesState extends Equatable {
  final CircleSubcategoriesStatus status;
  final List<CircleCategoryEntity> allSubcategories;
  final List<CircleCategoryEntity> filteredSubcategories;
  final CircleCategoryEntity? selectedSubcategory;
  final bool isOtherSelected;
  final String searchQuery;
  final String? errorMessage;

  const CircleSubcategoriesState({
    this.status = CircleSubcategoriesStatus.initial,
    this.allSubcategories = const [],
    this.filteredSubcategories = const [],
    this.selectedSubcategory,
    this.isOtherSelected = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  bool isCatSelected(CircleCategoryEntity cat) {
    if (isOtherSelected || selectedSubcategory == null) return false;
    if (selectedSubcategory!.id.isNotEmpty && cat.id.isNotEmpty) {
      if (selectedSubcategory!.id.toString() == cat.id.toString()) return true;
    }
    return selectedSubcategory!.name.trim().toLowerCase() == cat.name.trim().toLowerCase();
  }

  CircleSubcategoriesState copyWith({
    CircleSubcategoriesStatus? status,
    List<CircleCategoryEntity>? allSubcategories,
    List<CircleCategoryEntity>? filteredSubcategories,
    CircleCategoryEntity? selectedSubcategory,
    bool? isOtherSelected,
    String? searchQuery,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CircleSubcategoriesState(
      status: status ?? this.status,
      allSubcategories: allSubcategories ?? this.allSubcategories,
      filteredSubcategories: filteredSubcategories ?? this.filteredSubcategories,
      selectedSubcategory: clearSelected ? null : (selectedSubcategory ?? this.selectedSubcategory),
      isOtherSelected: isOtherSelected ?? this.isOtherSelected,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allSubcategories,
        filteredSubcategories,
        selectedSubcategory,
        isOtherSelected,
        searchQuery,
        errorMessage,
      ];
}
