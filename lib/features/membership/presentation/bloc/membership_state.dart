import 'package:equatable/equatable.dart';
import '../../domain/entities/checkout_session_entity.dart';
import '../../domain/entities/membership_plan_entity.dart';
import '../../domain/entities/subscription_history_entity.dart';
import '../../domain/entities/subscription_status_entity.dart';

enum MembershipStatus {
  initial,
  loading,
  loaded,
  checkoutLoading,
  checkoutReady,
  verifying,
  verificationSuccess,
  verificationFailed,
  error,
}

class MembershipState extends Equatable {
  final MembershipStatus status;
  final List<MembershipPlanEntity> plans;
  final MembershipPlanEntity? selectedPlan;
  final CheckoutSessionEntity? checkoutSession;
  final SubscriptionStatusEntity? subscriptionStatus;
  final List<SubscriptionHistoryEntity> history;
  final String? errorMessage;

  const MembershipState({
    this.status = MembershipStatus.initial,
    this.plans = const [],
    this.selectedPlan,
    this.checkoutSession,
    this.subscriptionStatus,
    this.history = const [],
    this.errorMessage,
  });

  MembershipState copyWith({
    MembershipStatus? status,
    List<MembershipPlanEntity>? plans,
    MembershipPlanEntity? selectedPlan,
    CheckoutSessionEntity? checkoutSession,
    SubscriptionStatusEntity? subscriptionStatus,
    List<SubscriptionHistoryEntity>? history,
    String? errorMessage,
  }) {
    return MembershipState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      checkoutSession: checkoutSession ?? this.checkoutSession,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        plans,
        selectedPlan,
        checkoutSession,
        subscriptionStatus,
        history,
        errorMessage,
      ];
}
