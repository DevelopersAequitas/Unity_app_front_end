import '../../domain/entities/leadership_interest_entity.dart';
import '../../domain/repositories/leadership_role_repository.dart';
import '../datasources/leadership_role_remote_datasource.dart';
import '../models/leadership_interest_model.dart';

class LeadershipRoleRepositoryImpl implements LeadershipRoleRepository {
  final LeadershipRoleRemoteDataSource remoteDataSource;

  const LeadershipRoleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitLeadershipInterest(LeadershipInterestEntity interest) async {
    final model = LeadershipInterestModel.fromEntity(interest);
    await remoteDataSource.submitLeadershipInterest(model);
  }
}
