import '../../domain/entities/collaboration_params.dart';

abstract class CollaborationsEvent {
  const CollaborationsEvent();
}

class LoadCollaborationsInitialData extends CollaborationsEvent {
  const LoadCollaborationsInitialData();
}

class SubmitCollaborationEvent extends CollaborationsEvent {
  final CollaborationParams params;
  const SubmitCollaborationEvent(this.params);
}

class FetchCollaborationHistoryEvent extends CollaborationsEvent {
  const FetchCollaborationHistoryEvent();
}

class AcceptCollaborationEvent extends CollaborationsEvent {
  final String collaborationId;
  const AcceptCollaborationEvent(this.collaborationId);
}
