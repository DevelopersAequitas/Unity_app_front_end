import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/speaker_submission_entity.dart';

abstract class SpeakerEvent extends Equatable {
  const SpeakerEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpeakerHistoryEvent extends SpeakerEvent {
  const FetchSpeakerHistoryEvent();
}

class SubmitSpeakerApplicationEvent extends SpeakerEvent {
  final SpeakerSubmissionEntity entity;
  final File? imageFile;

  const SubmitSpeakerApplicationEvent({
    required this.entity,
    this.imageFile,
  });

  @override
  List<Object?> get props => [entity, imageFile];
}

class ResetSpeakerStateEvent extends SpeakerEvent {
  const ResetSpeakerStateEvent();
}
