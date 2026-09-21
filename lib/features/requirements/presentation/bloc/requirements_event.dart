import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class RequirementsEvent extends Equatable {
  const RequirementsEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpenRequirementsEvent extends RequirementsEvent {
  const FetchOpenRequirementsEvent();
}

class FetchMyRequirementsEvent extends RequirementsEvent {
  const FetchMyRequirementsEvent();
}

class CreateRequirementEvent extends RequirementsEvent {
  final String subject;
  final String description;
  final String category;
  final String regionLabel;
  final String cityName;
  final String? mediaId;
  final File? attachment;

  const CreateRequirementEvent({
    required this.subject,
    required this.description,
    required this.category,
    required this.regionLabel,
    required this.cityName,
    this.mediaId,
    this.attachment,
  });

  @override
  List<Object?> get props => [
        subject,
        description,
        category,
        regionLabel,
        cityName,
        mediaId,
        attachment,
      ];
}

class CompleteRequirementEvent extends RequirementsEvent {
  final String id;
  const CompleteRequirementEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FulfillRequirementEvent extends RequirementsEvent {
  final String id;
  final String message;
  const FulfillRequirementEvent(this.id, this.message);

  @override
  List<Object?> get props => [id, message];
}
