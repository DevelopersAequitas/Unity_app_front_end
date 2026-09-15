import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_membership_plans_usecase.dart';
import '../../domain/usecases/get_subscription_history_usecase.dart';
import '../../domain/usecases/initiate_plan_checkout_usecase.dart';
import '../../domain/usecases/verify_checkout_status_usecase.dart';
import 'membership_event.dart';
import 'membership_state.dart';

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final GetMembershipPlansUseCase getMembershipPlansUseCase;
  final InitiatePlanCheckoutUseCase initiatePlanCheckoutUseCase;
  final VerifyCheckoutStatusUseCase verifyCheckoutStatusUseCase;
  final GetSubscriptionHistoryUseCase getSubscriptionHistoryUseCase;

  MembershipBloc({
    required this.getMembershipPlansUseCase,
    required this.initiatePlanCheckoutUseCase,
    required this.verifyCheckoutStatusUseCase,
    required this.getSubscriptionHistoryUseCase,
  }) : super(const MembershipState()) {
    on<MembershipPlansFetchRequested>(_onFetchPlans);
    on<MembershipCheckoutInitiated>(_onInitiateCheckout);
    on<MembershipCheckoutStatusVerified>(_onVerifyStatus);
    on<MembershipHistoryFetchRequested>(_onFetchHistory);
  }

  Future<void> _onFetchPlans(
    MembershipPlansFetchRequested event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.loading));
    try {
      final plans = await getMembershipPlansUseCase();
      final defaultPlan = plans.where((p) => p.isPopular).firstOrNull ??
          plans.firstOrNull;
      emit(state.copyWith(
        status: MembershipStatus.loaded,
        plans: plans,
        selectedPlan: defaultPlan,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MembershipStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onInitiateCheckout(
    MembershipCheckoutInitiated event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.checkoutLoading));
    try {
      final session = await initiatePlanCheckoutUseCase(event.planCode);
      emit(state.copyWith(
        status: MembershipStatus.checkoutReady,
        checkoutSession: session,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MembershipStatus.error,
        errorMessage: 'Unable to start checkout. Please try again.',
      ));
    }
  }

  Future<void> _onVerifyStatus(
    MembershipCheckoutStatusVerified event,
    Emitter<MembershipState> emit,
  ) async {
    emit(state.copyWith(status: MembershipStatus.verifying));
    try {
      final status = await verifyCheckoutStatusUseCase(event.hostedPageId);
      if (status.isSuccessful) {
        emit(state.copyWith(
          status: MembershipStatus.verificationSuccess,
          subscriptionStatus: status,
        ));
      } else {
        emit(state.copyWith(
          status: MembershipStatus.verificationFailed,
          subscriptionStatus: status,
          errorMessage: 'Payment not completed yet.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MembershipStatus.verificationFailed,
        errorMessage: 'Could not verify payment status.',
      ));
    }
  }

  Future<void> _onFetchHistory(
    MembershipHistoryFetchRequested event,
    Emitter<MembershipState> emit,
  ) async {
    try {
      final history = await getSubscriptionHistoryUseCase();
      emit(state.copyWith(history: history));
    } catch (_) {}
  }
}
