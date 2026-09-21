import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_coin_claim_activities_usecase.dart';
import '../../../domain/usecases/get_coin_claims_usecase.dart';
import '../../../domain/usecases/get_coin_wallet_data_usecase.dart';
import '../../../domain/usecases/submit_coin_claim_usecase.dart';
import 'coins_event.dart';
import 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final GetCoinWalletDataUseCase getCoinWalletDataUseCase;
  final GetCoinClaimActivitiesUseCase getCoinClaimActivitiesUseCase;
  final SubmitCoinClaimUseCase submitCoinClaimUseCase;
  final GetCoinClaimsUseCase getCoinClaimsUseCase;

  CoinsBloc({
    required this.getCoinWalletDataUseCase,
    required this.getCoinClaimActivitiesUseCase,
    required this.submitCoinClaimUseCase,
    required this.getCoinClaimsUseCase,
  }) : super(const CoinsState()) {
    on<FetchCoinsWalletEvent>(_onFetchWallet);
    on<FetchCoinClaimActivitiesEvent>(_onFetchActivities);
    on<FetchCoinClaimsEvent>(_onFetchClaims);
    on<SubmitCoinClaimEvent>(_onSubmitClaim);
    on<ResetCoinClaimStatusEvent>(_onResetClaimStatus);
  }

  Future<void> _onFetchWallet(
    FetchCoinsWalletEvent event,
    Emitter<CoinsState> emit,
  ) async {
    if (!event.isRefresh && state.status == CoinsStatus.initial) {
      emit(state.copyWith(status: CoinsStatus.loading));
    }
    try {
      final wallet = await getCoinWalletDataUseCase();
      emit(state.copyWith(
        status: CoinsStatus.success,
        wallet: wallet,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CoinsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchActivities(
    FetchCoinClaimActivitiesEvent event,
    Emitter<CoinsState> emit,
  ) async {
    if (!event.isRefresh && state.activitiesStatus == CoinsStatus.initial) {
      emit(state.copyWith(activitiesStatus: CoinsStatus.loading));
    }
    try {
      final activities = await getCoinClaimActivitiesUseCase();
      emit(state.copyWith(
        activitiesStatus: CoinsStatus.success,
        activities: activities,
        activitiesError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        activitiesStatus: CoinsStatus.failure,
        activitiesError: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onFetchClaims(
    FetchCoinClaimsEvent event,
    Emitter<CoinsState> emit,
  ) async {
    if (!event.isRefresh && state.claimsStatus == CoinsStatus.initial) {
      emit(state.copyWith(claimsStatus: CoinsStatus.loading));
    }
    try {
      final claims = await getCoinClaimsUseCase(status: event.status);
      emit(state.copyWith(
        claimsStatus: CoinsStatus.success,
        claims: claims,
        claimsError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        claimsStatus: CoinsStatus.failure,
        claimsError: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onSubmitClaim(
    SubmitCoinClaimEvent event,
    Emitter<CoinsState> emit,
  ) async {
    emit(state.copyWith(
      claimSubmitStatus: CoinsClaimStatus.submitting,
      claimSubmitMessage: null,
    ));

    try {
      final result = await submitCoinClaimUseCase(
        SubmitCoinClaimParams(
          activityCode: event.activityCode,
          fields: event.fields,
          proofFile: event.proofFile,
        ),
      );

      final message = result['message']?.toString() ?? 'Coin claim submitted successfully.';
      emit(state.copyWith(
        claimSubmitStatus: CoinsClaimStatus.success,
        claimSubmitMessage: message,
      ));

      add(const FetchCoinClaimsEvent(isRefresh: true));
      add(const FetchCoinsWalletEvent(isRefresh: true));
    } catch (e) {
      emit(state.copyWith(
        claimSubmitStatus: CoinsClaimStatus.failure,
        claimSubmitMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onResetClaimStatus(
    ResetCoinClaimStatusEvent event,
    Emitter<CoinsState> emit,
  ) {
    emit(state.copyWith(
      claimSubmitStatus: CoinsClaimStatus.initial,
      claimSubmitMessage: null,
    ));
  }
}
