import '../../domain/entities/checkout_session_entity.dart';
import '../../domain/entities/membership_plan_entity.dart';
import '../../domain/entities/subscription_history_entity.dart';
import '../../domain/entities/subscription_status_entity.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/membership_remote_datasource.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final MembershipRemoteDataSource remoteDataSource;

  MembershipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MembershipPlanEntity>> getMembershipPlans() {
    return remoteDataSource.getMembershipPlans();
  }

  @override
  Future<CheckoutSessionEntity> initiatePlanCheckout(String planCode) {
    return remoteDataSource.initiatePlanCheckout(planCode);
  }

  @override
  Future<SubscriptionStatusEntity> verifyCheckoutStatus(String hostedPageId) {
    return remoteDataSource.verifyCheckoutStatus(hostedPageId);
  }

  @override
  Future<List<SubscriptionHistoryEntity>> getSubscriptionHistory() {
    return remoteDataSource.getSubscriptionHistory();
  }
}
