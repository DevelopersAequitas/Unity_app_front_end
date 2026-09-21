import '../entities/collaboration.dart';
import '../entities/collaboration_params.dart';
import '../entities/collaboration_type.dart';
import '../entities/industry.dart';

abstract class CollaborationsRepository {
  Future<List<IndustryParent>> getIndustriesTree();
  Future<List<CollaborationType>> getCollaborationTypes();
  Future<void> submitCollaboration(CollaborationParams params);
  Future<List<Collaboration>> getCollaborationHistory();
  Future<void> acceptCollaboration(String collaborationId);
}
