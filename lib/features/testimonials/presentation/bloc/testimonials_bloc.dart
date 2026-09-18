import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_given_testimonials_usecase.dart';
import '../../domain/usecases/get_received_testimonials_usecase.dart';
import '../../domain/usecases/get_user_testimonials_usecase.dart';
import 'testimonials_event.dart';
import 'testimonials_state.dart';

class TestimonialsBloc extends Bloc<TestimonialsEvent, TestimonialsState> {
  final GetReceivedTestimonialsUseCase getReceivedTestimonialsUseCase;
  final GetGivenTestimonialsUseCase getGivenTestimonialsUseCase;
  final GetUserTestimonialsUseCase getUserTestimonialsUseCase;

  TestimonialsBloc({
    required this.getReceivedTestimonialsUseCase,
    required this.getGivenTestimonialsUseCase,
    required this.getUserTestimonialsUseCase,
  }) : super(const TestimonialsState()) {
    on<TestimonialsTabChanged>(_onTabChanged);
    on<TestimonialsFetchReceivedRequested>(_onFetchReceived);
    on<TestimonialsLoadMoreReceivedRequested>(_onLoadMoreReceived);
    on<TestimonialsFetchGivenRequested>(_onFetchGiven);
    on<TestimonialsLoadMoreGivenRequested>(_onLoadMoreGiven);
    on<TestimonialsFetchUserRequested>(_onFetchUser);
    on<TestimonialsLoadMoreUserRequested>(_onLoadMoreUser);
    on<TestimonialCreatedLocally>(_onCreatedLocally);
    on<TestimonialsSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });
  }

  void _onTabChanged(
    TestimonialsTabChanged event,
    Emitter<TestimonialsState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
    if (event.tab == TestimonialTab.given &&
        state.givenStatus == TestimonialsStatus.initial) {
      add(const TestimonialsFetchGivenRequested());
    } else if (event.tab == TestimonialTab.received &&
        state.receivedStatus == TestimonialsStatus.initial) {
      add(const TestimonialsFetchReceivedRequested());
    }
  }

  Future<void> _onFetchReceived(
    TestimonialsFetchReceivedRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    if (state.receivedTestimonials.isEmpty || event.forceRefresh) {
      emit(state.copyWith(receivedStatus: TestimonialsStatus.loading));
    }
    try {
      final res = await getReceivedTestimonialsUseCase(page: 1);
      emit(state.copyWith(
        receivedStatus: TestimonialsStatus.success,
        receivedTestimonials: res.items,
        receivedPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        receivedStatus: state.receivedTestimonials.isNotEmpty
            ? TestimonialsStatus.success
            : TestimonialsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreReceived(
    TestimonialsLoadMoreReceivedRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    if (state.isLoadingMore || !state.receivedPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.receivedPagination.currentPage + 1;
      final res = await getReceivedTestimonialsUseCase(
        page: nextPage,
        perPage: state.receivedPagination.perPage,
      );

      final existingIds = state.receivedTestimonials.map((e) => e.id).toSet();
      final newItems = res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        receivedTestimonials: [...state.receivedTestimonials, ...newItems],
        receivedPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchGiven(
    TestimonialsFetchGivenRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    if (state.givenTestimonials.isEmpty || event.forceRefresh) {
      emit(state.copyWith(givenStatus: TestimonialsStatus.loading));
    }
    try {
      final res = await getGivenTestimonialsUseCase(page: 1);
      emit(state.copyWith(
        givenStatus: TestimonialsStatus.success,
        givenTestimonials: res.items,
        givenPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        givenStatus: state.givenTestimonials.isNotEmpty
            ? TestimonialsStatus.success
            : TestimonialsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreGiven(
    TestimonialsLoadMoreGivenRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    if (state.isLoadingMore || !state.givenPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.givenPagination.currentPage + 1;
      final res = await getGivenTestimonialsUseCase(
        page: nextPage,
        perPage: state.givenPagination.perPage,
      );

      final existingIds = state.givenTestimonials.map((e) => e.id).toSet();
      final newItems = res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        givenTestimonials: [...state.givenTestimonials, ...newItems],
        givenPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchUser(
    TestimonialsFetchUserRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    emit(state.copyWith(receivedStatus: TestimonialsStatus.loading));
    try {
      final res = await getUserTestimonialsUseCase(event.userId, page: 1);
      emit(state.copyWith(
        receivedStatus: TestimonialsStatus.success,
        userTestimonials: res.items,
        receivedTestimonials: res.items,
        userPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        receivedStatus: TestimonialsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreUser(
    TestimonialsLoadMoreUserRequested event,
    Emitter<TestimonialsState> emit,
  ) async {
    if (state.isLoadingMore || !state.userPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.userPagination.currentPage + 1;
      final res = await getUserTestimonialsUseCase(
        event.userId,
        page: nextPage,
        perPage: state.userPagination.perPage,
      );

      final existingIds = state.userTestimonials.map((e) => e.id).toSet();
      final newItems = res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        userTestimonials: [...state.userTestimonials, ...newItems],
        receivedTestimonials: [...state.userTestimonials, ...newItems],
        userPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void _onCreatedLocally(
    TestimonialCreatedLocally event,
    Emitter<TestimonialsState> emit,
  ) {
    final updatedGiven = [event.testimonial, ...state.givenTestimonials];
    emit(state.copyWith(
      givenTestimonials: updatedGiven,
      givenStatus: TestimonialsStatus.success,
    ));
  }
}
