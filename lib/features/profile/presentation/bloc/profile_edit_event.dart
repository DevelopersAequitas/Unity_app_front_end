import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSaveSectionRequested extends ProfileEditEvent {
  final Map<String, dynamic> updateData;
  final String sectionName;

  const ProfileSaveSectionRequested({
    required this.updateData,
    required this.sectionName,
  });

  @override
  List<Object?> get props => [updateData, sectionName];
}

class ProfileUploadPhotoRequested extends ProfileEditEvent {
  final File file;
  final bool isCover;

  const ProfileUploadPhotoRequested({
    required this.file,
    this.isCover = false,
  });

  @override
  List<Object?> get props => [file, isCover];
}

class ProfileUploadVideoRequested extends ProfileEditEvent {
  final File file;

  const ProfileUploadVideoRequested({required this.file});

  @override
  List<Object?> get props => [file];
}

class ProfileUploadProgressUpdated extends ProfileEditEvent {
  final double progress;

  const ProfileUploadProgressUpdated(this.progress);

  @override
  List<Object?> get props => [progress];
}
