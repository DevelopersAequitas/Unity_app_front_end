import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';

enum CirclesStatus { initial, loading, success, error }

class CirclesState extends Equatable {
  final CirclesStatus status;
  final List<CircleEntity> myCircles;
  final List<CircleCategoryEntity> categories;
  final List<CircleJoinRequestEntity> myJoinRequests;
  final int activeTab; // 0 = My Circles, 1 = Join a Circle
  final String searchQuery;
  final CircleEntity? selectedCircle;
  final String? errorMessage;

  const CirclesState({
    this.status = CirclesStatus.initial,
    this.myCircles = const [],
    this.categories = const [],
    this.myJoinRequests = const [],
    this.activeTab = 0,
    this.searchQuery = '',
    this.selectedCircle,
    this.errorMessage,
  });

  CircleJoinRequestEntity? getJoinRequestForCategory(CircleCategoryEntity category) {
    if (myJoinRequests.isEmpty) return null;
    final catId = category.id.trim();
    final catName = category.name.trim().toLowerCase();
    for (final req in myJoinRequests) {
      if (req.categoryId.isNotEmpty && req.categoryId == catId) return req;
      if (req.categoryName.trim().toLowerCase() == catName) return req;
      if (req.circleId.isNotEmpty && req.circleId == catId) return req;
      if (req.circleName.trim().toLowerCase() == catName) return req;
      if (category.slug != null && category.slug!.isNotEmpty) {
        if (req.categoryName.trim().toLowerCase() == category.slug!.trim().toLowerCase() ||
            req.circleName.trim().toLowerCase() == category.slug!.trim().toLowerCase()) {
          return req;
        }
      }
    }
    return null;
  }

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

  List<CircleJoinRequestEntity> get activeJoinRequests {
    return myJoinRequests.where((r) => !r.isRejected).toList();
  }

  List<CircleJoinRequestEntity> get filteredMyJoinRequests {
    final active = activeJoinRequests;
    if (searchQuery.trim().isEmpty) return active;
    final q = searchQuery.toLowerCase();
    return active.where((r) {
      return r.categoryName.toLowerCase().contains(q) ||
          (r.level4CategoryName?.toLowerCase().contains(q) ?? false) ||
          r.circleName.toLowerCase().contains(q) ||
          r.statusLabel.toLowerCase().contains(q) ||
          r.displayStatus.toLowerCase().contains(q) ||
          r.reasonForJoining.toLowerCase().contains(q);
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
    List<CircleJoinRequestEntity>? myJoinRequests,
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
      myJoinRequests: myJoinRequests ?? this.myJoinRequests,
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
        myJoinRequests,
        activeTab,
        searchQuery,
        selectedCircle,
        errorMessage,
      ];
}
