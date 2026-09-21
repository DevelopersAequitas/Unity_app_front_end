import 'package:equatable/equatable.dart';
import '../../domain/entities/requirement.dart';

enum RequirementsStatus { initial, loading, loaded, submitting, success, error }

class RequirementsState extends Equatable {
  final RequirementsStatus status;
  final List<Requirement> openRequirements;
  final List<Requirement> myRequirements;
  final String? successMessage;
  final String? errorMessage;

  const RequirementsState({
    this.status = RequirementsStatus.initial,
    this.openRequirements = const [],
    this.myRequirements = const [],
    this.successMessage,
    this.errorMessage,
  });

  RequirementsState copyWith({
    RequirementsStatus? status,
    List<Requirement>? openRequirements,
    List<Requirement>? myRequirements,
    String? successMessage,
    String? errorMessage,
  }) {
    return RequirementsState(
      status: status ?? this.status,
      openRequirements: openRequirements ?? this.openRequirements,
      myRequirements: myRequirements ?? this.myRequirements,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        openRequirements,
        myRequirements,
        successMessage,
        errorMessage,
      ];
}
