import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/usecases/get_given_referrals_usecase.dart';
import '../../domain/usecases/get_received_referrals_usecase.dart';
import '../../domain/usecases/get_referral_statuses_usecase.dart';
import '../../domain/usecases/get_referrals_stats_usecase.dart';
import '../../domain/usecases/update_referral_status_usecase.dart';
import 'referrals_event.dart';
import 'referrals_state.dart';

class ReferralsBloc extends Bloc<ReferralsEvent, ReferralsState> {
  final GetReceivedReferralsUseCase getReceivedReferralsUseCase;
  final GetGivenReferralsUseCase getGivenReferralsUseCase;
  final GetReferralsStatsUseCase getReferralsStatsUseCase;
  final GetReferralStatusesUseCase getReferralStatusesUseCase;
  final UpdateReferralStatusUseCase updateReferralStatusUseCase;

  ReferralsBloc({
    required this.getReceivedReferralsUseCase,
    required this.getGivenReferralsUseCase,
    required this.getReferralsStatsUseCase,
    required this.getReferralStatusesUseCase,
    required this.updateReferralStatusUseCase,
  }) : super(const ReferralsState()) {
    on<ReferralsTabChanged>(_onTabChanged);
    on<ReferralsFetchStatsRequested>(_onFetchStats);
    on<ReferralsFetchReceivedRequested>(_onFetchReceived);
    on<ReferralsLoadMoreReceivedRequested>(_onLoadMoreReceived);
    on<ReferralsFetchGivenRequested>(_onFetchGiven);
    on<ReferralsLoadMoreGivenRequested>(_onLoadMoreGiven);
    on<ReferralsStatusesFetchRequested>(_onFetchStatuses);
    on<ReferralStatusUpdated>(_onStatusUpdated);
    on<ReferralCreatedLocally>(_onCreatedLocally);
    on<ReferralsSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });
    on<ReferralsStatusFilterChanged>((event, emit) {
      emit(state.copyWith(
        statusFilter: event.statusFilter,
        clearStatusFilter: event.statusFilter == null,
      ));
    });
  }

  void _onTabChanged(
    ReferralsTabChanged event,
    Emitter<ReferralsState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
    if (event.tab == ReferralTab.given &&
        state.givenStatus == ReferralsStatus.initial) {
      add(const ReferralsFetchGivenRequested());
    } else if (event.tab == ReferralTab.received &&
        state.receivedStatus == ReferralsStatus.initial) {
      add(const ReferralsFetchReceivedRequested());
    }
  }

  Future<void> _onFetchStats(
    ReferralsFetchStatsRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    try {
      final stats = await getReferralsStatsUseCase();
      emit(state.copyWith(stats: stats));
    } catch (_) {
      // Ignore stats background error
    }
  }

  Future<void> _onFetchReceived(
    ReferralsFetchReceivedRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    if (state.receivedReferrals.isEmpty || event.forceRefresh) {
      emit(state.copyWith(receivedStatus: ReferralsStatus.loading));
    }
    try {
      final res = await getReceivedReferralsUseCase(page: 1);
      emit(state.copyWith(
        receivedStatus: ReferralsStatus.success,
        receivedReferrals: res.items,
        receivedPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        receivedStatus: state.receivedReferrals.isNotEmpty
            ? ReferralsStatus.success
            : ReferralsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreReceived(
    ReferralsLoadMoreReceivedRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    if (state.isLoadingMore || !state.receivedPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.receivedPagination.currentPage + 1;
      final res = await getReceivedReferralsUseCase(
        page: nextPage,
        perPage: state.receivedPagination.perPage,
      );

      final existingIds = state.receivedReferrals.map((e) => e.id).toSet();
      final newItems =
          res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        receivedReferrals: [...state.receivedReferrals, ...newItems],
        receivedPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchGiven(
    ReferralsFetchGivenRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    if (state.givenReferrals.isEmpty || event.forceRefresh) {
      emit(state.copyWith(givenStatus: ReferralsStatus.loading));
    }
    try {
      final res = await getGivenReferralsUseCase(page: 1);
      emit(state.copyWith(
        givenStatus: ReferralsStatus.success,
        givenReferrals: res.items,
        givenPagination: res.pagination,
      ));
    } catch (e) {
      emit(state.copyWith(
        givenStatus: state.givenReferrals.isNotEmpty
            ? ReferralsStatus.success
            : ReferralsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreGiven(
    ReferralsLoadMoreGivenRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    if (state.isLoadingMore || !state.givenPagination.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.givenPagination.currentPage + 1;
      final res = await getGivenReferralsUseCase(
        page: nextPage,
        perPage: state.givenPagination.perPage,
      );

      final existingIds = state.givenReferrals.map((e) => e.id).toSet();
      final newItems =
          res.items.where((e) => !existingIds.contains(e.id)).toList();

      emit(state.copyWith(
        isLoadingMore: false,
        givenReferrals: [...state.givenReferrals, ...newItems],
        givenPagination: res.pagination,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFetchStatuses(
    ReferralsStatusesFetchRequested event,
    Emitter<ReferralsState> emit,
  ) async {
    try {
      final statuses = await getReferralStatusesUseCase();
      if (statuses.isNotEmpty) {
        emit(state.copyWith(availableStatuses: statuses));
      }
    } catch (_) {
      // keep default fallback statuses
    }
  }

  Future<void> _onStatusUpdated(
    ReferralStatusUpdated event,
    Emitter<ReferralsState> emit,
  ) async {
    emit(state.copyWith(isUpdatingStatus: true));

    // Optimistically update in state
    ReferralEntity updateEntity(ReferralEntity item) {
      if (item.id == event.referralId) {
        return ReferralEntity(
          id: item.id,
          fromUserId: item.fromUserId,
          toUserId: item.toUserId,
          referralType: item.referralType,
          referralDate: item.referralDate,
          referralOf: item.referralOf,
          phone: item.phone,
          email: item.email,
          address: item.address,
          hotValue: item.hotValue,
          remarks: item.remarks,
          statusId: event.statusId,
          statusName: event.statusName,
          peerName: item.peerName,
          peerPhotoUrl: item.peerPhotoUrl,
          peerDesignation: item.peerDesignation,
          peerCompany: item.peerCompany,
          peerLocation: item.peerLocation,
          city: item.city,
          category: item.category,
          lifeImpactedCount: item.lifeImpactedCount,
          isPro: item.isPro,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          coinsEarned: item.coinsEarned,
          impactEarned: item.impactEarned,
        );
      }
      return item;
    }

    final updatedReceived = state.receivedReferrals.map(updateEntity).toList();
    final updatedGiven = state.givenReferrals.map(updateEntity).toList();

    emit(state.copyWith(
      receivedReferrals: updatedReceived,
      givenReferrals: updatedGiven,
    ));

    try {
      await updateReferralStatusUseCase(
        id: event.referralId,
        statusId: event.statusId,
      );
      emit(state.copyWith(isUpdatingStatus: false));
    } catch (e) {
      emit(state.copyWith(
        isUpdatingStatus: false,
        errorMessage: 'Failed to update status: $e',
      ));
    }
  }

  void _onCreatedLocally(
    ReferralCreatedLocally event,
    Emitter<ReferralsState> emit,
  ) {
    final updatedGiven = [event.referral, ...state.givenReferrals];
    emit(state.copyWith(
      givenReferrals: updatedGiven,
      givenStatus: ReferralsStatus.success,
    ));
  }
}
