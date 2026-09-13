import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_entity.dart';

enum CirclesStatus { initial, loading, success, error }

class CirclesState extends Equatable {
  final CirclesStatus status;
  final List<CircleEntity> myCircles;
  final List<CircleCategoryEntity> categories;
  final int activeTab; // 0 = My Circles, 1 = Join a Circle
  final String searchQuery;
  final CircleEntity? selectedCircle;
  final String? errorMessage;

  const CirclesState({
    this.status = CirclesStatus.initial,
    this.myCircles = const [],
    this.categories = const [],
    this.activeTab = 0,
    this.searchQuery = '',
    this.selectedCircle,
    this.errorMessage,
  });

  List<CircleEntity> get filteredMyCircles {
    if (searchQuery.trim().isEmpty) return myCircles;
    final q = searchQuery.toLowerCase();
    return myCircles.where((c) {
      return c.name.toLowerCase().contains(q) ||
          (c.category?.toLowerCase().contains(q) ?? false) ||
          (c.city?.toLowerCase().contains(q) ?? false) ||
          (c.description?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  List<CircleCategoryEntity> get industryCategories {
    var active = categories.where((c) => c.isActive).toList();
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      active = active.where((c) => c.name.toLowerCase().contains(q) || (c.slug?.toLowerCase().contains(q) ?? false)).toList();
      return active;
    }
    active.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (active.length <= 9) return active;
    return active.sublist(0, 9);
  }

  List<CircleCategoryEntity> get interestCategories {
    if (searchQuery.trim().isNotEmpty) {
      return const [];
    }
    final active = categories.where((c) => c.isActive).toList();
    active.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (active.length <= 9) return const [];
    return active.sublist(9);
  }

  CirclesState copyWith({
    CirclesStatus? status,
    List<CircleEntity>? myCircles,
    List<CircleCategoryEntity>? categories,
    int? activeTab,
    String? searchQuery,
    CircleEntity? selectedCircle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CirclesState(
      status: status ?? this.status,
      myCircles: myCircles ?? this.myCircles,
      categories: categories ?? this.categories,
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCircle: selectedCircle ?? this.selectedCircle,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        myCircles,
        categories,
        activeTab,
        searchQuery,
        selectedCircle,
        errorMessage,
      ];
}
