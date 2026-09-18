import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_given_business_deals_usecase.dart';
import '../../domain/usecases/get_received_business_deals_usecase.dart';
import '../../domain/usecases/get_user_business_deals_usecase.dart';
import 'business_deals_event.dart';
import 'business_deals_state.dart';

class BusinessDealsBloc extends Bloc<BusinessDealsEvent, BusinessDealsState> {
  final GetReceivedBusinessDealsUseCase getReceivedBusinessDealsUseCase;
  final GetGivenBusinessDealsUseCase getGivenBusinessDealsUseCase;
  final GetUserBusinessDealsUseCase getUserBusinessDealsUseCase;

  BusinessDealsBloc({
    required this.getReceivedBusinessDealsUseCase,
    required this.getGivenBusinessDealsUseCase,
    required this.getUserBusinessDealsUseCase,
  }) : super(const BusinessDealsState()) {
    on<BusinessDealsTabChanged>(_onTabChanged);
    on<BusinessDealsFetchReceivedRequested>(_onFetchReceived);
    on<BusinessDealsLoadMoreReceivedRequested>(_onLoadMoreReceived);
    on<BusinessDealsFetchGivenRequested>(_onFetchGiven);
    on<BusinessDealsLoadMoreGivenRequested>(_onLoadMoreGiven);
    on<BusinessDealsFetchUserRequested>(_onFetchUser);
    on<BusinessDealsLoadMoreUserRequested>(_onLoadMoreUser);
    on<BusinessDealCreatedLocally>(_onCreatedLocally);
    on<BusinessDealsSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });
  }

  void _onTabChanged(
    BusinessDealsTabChanged event,
    Emitter<BusinessDealsState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
    if (event.tab == BusinessDealTab.given &&
        state.givenStatus == BusinessDealsStatus.initial) {
      add(const BusinessDealsFetchGivenRequested());
    } else if (event.tab == BusinessDealTab.received &&
        state.receivedStatus == BusinessDealsStatus.initial) {
      add(const BusinessDealsFetchReceivedRequested());
    }
  }

  Future<void> _onFetchReceived(
    BusinessDealsFetchReceivedRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    if (state.receivedDeals.isEmpty || event.forceRefresh) {
      emit(state.copyWith(receivedStatus: BusinessDealsStatus.loading));
    }
    try {
      final res = await getReceivedBusinessDealsUseCase(page: 1);
      emit(state.copyWith(
        receivedStatus: BusinessDealsStatus.success,
        receivedDeals: res.items,
        receivedPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        receivedStatus: state.receivedDeals.isNotEmpty
            ? BusinessDealsStatus.success
            : BusinessDealsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreReceived(
    BusinessDealsLoadMoreReceivedRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    if (state.isLoadingMore || !state.receivedPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.receivedPagination.currentPage + 1;
      final res = await getReceivedBusinessDealsUseCase(
        page: nextPage,
        perPage: state.receivedPagination.perPage,
      );

      final existingIds = state.receivedDeals.map((e) => e.id).toSet();
      final newItems =
          res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        receivedDeals: [...state.receivedDeals, ...newItems],
        receivedPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchGiven(
    BusinessDealsFetchGivenRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    if (state.givenDeals.isEmpty || event.forceRefresh) {
      emit(state.copyWith(givenStatus: BusinessDealsStatus.loading));
    }
    try {
      final res = await getGivenBusinessDealsUseCase(page: 1);
      emit(state.copyWith(
        givenStatus: BusinessDealsStatus.success,
        givenDeals: res.items,
        givenPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        givenStatus: state.givenDeals.isNotEmpty
            ? BusinessDealsStatus.success
            : BusinessDealsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreGiven(
    BusinessDealsLoadMoreGivenRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    if (state.isLoadingMore || !state.givenPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.givenPagination.currentPage + 1;
      final res = await getGivenBusinessDealsUseCase(
        page: nextPage,
        perPage: state.givenPagination.perPage,
      );

      final existingIds = state.givenDeals.map((e) => e.id).toSet();
      final newItems =
          res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        givenDeals: [...state.givenDeals, ...newItems],
        givenPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchUser(
    BusinessDealsFetchUserRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    emit(state.copyWith(receivedStatus: BusinessDealsStatus.loading));
    try {
      final res = await getUserBusinessDealsUseCase(event.userId, page: 1);
      emit(state.copyWith(
        receivedStatus: BusinessDealsStatus.success,
        userDeals: res.items,
        receivedDeals: res.items,
        userPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        receivedStatus: BusinessDealsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreUser(
    BusinessDealsLoadMoreUserRequested event,
    Emitter<BusinessDealsState> emit,
  ) async {
    if (state.isLoadingMore || !state.userPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.userPagination.currentPage + 1;
      final res = await getUserBusinessDealsUseCase(
        event.userId,
        page: nextPage,
        perPage: state.userPagination.perPage,
      );

      final existingIds = state.userDeals.map((e) => e.id).toSet();
      final newItems =
          res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        userDeals: [...state.userDeals, ...newItems],
        receivedDeals: [...state.userDeals, ...newItems],
        userPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void _onCreatedLocally(
    BusinessDealCreatedLocally event,
    Emitter<BusinessDealsState> emit,
  ) {
    final updatedGiven = [event.deal, ...state.givenDeals];
    emit(state.copyWith(
      givenDeals: updatedGiven,
      givenStatus: BusinessDealsStatus.success,
    ));
  }
}
