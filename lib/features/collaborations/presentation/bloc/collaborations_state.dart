import '../../domain/entities/collaboration.dart';
import '../../domain/entities/collaboration_type.dart';
import '../../domain/entities/industry.dart';

enum CollaborationsStatus { initial, loading, loaded, submitting, success, error }

class CollaborationsState {
  final CollaborationsStatus status;
  final List<IndustryParent> industries;
  final List<CollaborationType> collaborationTypes;
  final List<Collaboration> collaborations;
  final String? successMessage;
  final String? errorMessage;

  const CollaborationsState({
    this.status = CollaborationsStatus.initial,
    this.industries = const [],
    this.collaborationTypes = const [],
    this.collaborations = const [],
    this.successMessage,
    this.errorMessage,
  });

  CollaborationsState copyWith({
    CollaborationsStatus? status,
    List<IndustryParent>? industries,
    List<CollaborationType>? collaborationTypes,
    List<Collaboration>? collaborations,
    String? successMessage,
    String? errorMessage,
  }) {
    return CollaborationsState(
      status: status ?? this.status,
      industries: industries ?? this.industries,
      collaborationTypes: collaborationTypes ?? this.collaborationTypes,
      collaborations: collaborations ?? this.collaborations,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
