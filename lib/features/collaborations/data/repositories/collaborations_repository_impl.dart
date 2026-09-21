import '../../domain/entities/collaboration.dart';
import '../../domain/entities/collaboration_params.dart';
import '../../domain/entities/collaboration_type.dart';
import '../../domain/entities/industry.dart';
import '../../domain/repositories/collaborations_repository.dart';
import '../datasources/collaborations_remote_datasource.dart';

class CollaborationsRepositoryImpl implements CollaborationsRepository {
  final CollaborationsRemoteDataSource remoteDataSource;

  const CollaborationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<IndustryParent>> getIndustriesTree() async {
    return await remoteDataSource.getIndustriesTree();
  }

  @override
  Future<List<CollaborationType>> getCollaborationTypes() async {
    return await remoteDataSource.getCollaborationTypes();
  }

  @override
  Future<void> submitCollaboration(CollaborationParams params) async {
    return await remoteDataSource.submitCollaboration(params);
  }

  @override
  Future<List<Collaboration>> getCollaborationHistory() async {
    return await remoteDataSource.getCollaborationHistory();
  }

  @override
  Future<void> acceptCollaboration(String collaborationId) async {
    return await remoteDataSource.acceptCollaboration(collaborationId);
  }
}
