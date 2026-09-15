import 'package:unity_app/features/membership/domain/entities/checkout_session_entity.dart';
import 'package:unity_app/features/membership/domain/entities/membership_plan_entity.dart';
import 'package:unity_app/features/membership/domain/entities/subscription_history_entity.dart';
import 'package:unity_app/features/membership/domain/entities/subscription_status_entity.dart';

abstract class MembershipRepository {
  Future<List<MembershipPlanEntity>> getMembershipPlans();
  Future<CheckoutSessionEntity> initiatePlanCheckout(String planCode);
  Future<SubscriptionStatusEntity> verifyCheckoutStatus(String hostedPageId);
  Future<List<SubscriptionHistoryEntity>> getSubscriptionHistory();
}
