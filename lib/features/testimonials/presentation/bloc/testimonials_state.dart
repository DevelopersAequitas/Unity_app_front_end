import 'package:equatable/equatable.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/entities/testimonial_pagination_entity.dart';
import 'testimonials_event.dart';

enum TestimonialsStatus { initial, loading, success, failure }

class TestimonialsState extends Equatable {
  final TestimonialTab activeTab;
  final TestimonialsStatus receivedStatus;
  final TestimonialsStatus givenStatus;
  final List<TestimonialEntity> receivedTestimonials;
  final List<TestimonialEntity> givenTestimonials;
  final List<TestimonialEntity> userTestimonials;
  final TestimonialPaginationEntity receivedPagination;
  final TestimonialPaginationEntity givenPagination;
  final TestimonialPaginationEntity userPagination;
  final bool isLoadingMore;
  final String searchQuery;
  final String? errorMessage;

  const TestimonialsState({
    this.activeTab = TestimonialTab.received,
    this.receivedStatus = TestimonialsStatus.initial,
    this.givenStatus = TestimonialsStatus.initial,
    this.receivedTestimonials = const [],
    this.givenTestimonials = const [],
    this.userTestimonials = const [],
    this.receivedPagination = const TestimonialPaginationEntity(),
    this.givenPagination = const TestimonialPaginationEntity(),
    this.userPagination = const TestimonialPaginationEntity(),
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  bool _matchesQuery(TestimonialEntity t, String query) {
    if (query.trim().isEmpty) return true;
    final q = query.trim().toLowerCase();
    final name = t.peerName.toLowerCase();
    final city = (t.city ?? t.peerLocation ?? '').toLowerCase();
    final company = (t.peerCompany ?? '').toLowerCase();
    final designation = (t.peerDesignation ?? '').toLowerCase();
    final category = (t.category ?? '').toLowerCase();
    final content = t.content.toLowerCase();

    return name.contains(q) ||
        city.contains(q) ||
        company.contains(q) ||
        designation.contains(q) ||
        category.contains(q) ||
        content.contains(q);
  }

  List<TestimonialEntity> get currentList {
    final list = activeTab == TestimonialTab.received
        ? receivedTestimonials
        : givenTestimonials;
    if (searchQuery.trim().isEmpty) return list;
    return list.where((t) => _matchesQuery(t, searchQuery)).toList();
  }

  TestimonialsStatus get currentStatus =>
      activeTab == TestimonialTab.received ? receivedStatus : givenStatus;

  TestimonialPaginationEntity get currentPagination =>
      activeTab == TestimonialTab.received ? receivedPagination : givenPagination;

  // Compatibility getter for widgets using state.testimonials
  List<TestimonialEntity> get testimonials =>
      userTestimonials.isNotEmpty ? userTestimonials : currentList;

  List<TestimonialEntity> get filteredUserTestimonials {
    if (searchQuery.trim().isEmpty) return userTestimonials;
    return userTestimonials.where((t) => _matchesQuery(t, searchQuery)).toList();
  }

  TestimonialsState copyWith({
    TestimonialTab? activeTab,
    TestimonialsStatus? receivedStatus,
    TestimonialsStatus? givenStatus,
    List<TestimonialEntity>? receivedTestimonials,
    List<TestimonialEntity>? givenTestimonials,
    List<TestimonialEntity>? userTestimonials,
    TestimonialPaginationEntity? receivedPagination,
    TestimonialPaginationEntity? givenPagination,
    TestimonialPaginationEntity? userPagination,
    bool? isLoadingMore,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TestimonialsState(
      activeTab: activeTab ?? this.activeTab,
      receivedStatus: receivedStatus ?? this.receivedStatus,
      givenStatus: givenStatus ?? this.givenStatus,
      receivedTestimonials: receivedTestimonials ?? this.receivedTestimonials,
      givenTestimonials: givenTestimonials ?? this.givenTestimonials,
      userTestimonials: userTestimonials ?? this.userTestimonials,
      receivedPagination: receivedPagination ?? this.receivedPagination,
      givenPagination: givenPagination ?? this.givenPagination,
      userPagination: userPagination ?? this.userPagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        receivedStatus,
        givenStatus,
        receivedTestimonials,
        givenTestimonials,
        userTestimonials,
        receivedPagination,
        givenPagination,
        userPagination,
        isLoadingMore,
        searchQuery,
        errorMessage,
      ];
}
