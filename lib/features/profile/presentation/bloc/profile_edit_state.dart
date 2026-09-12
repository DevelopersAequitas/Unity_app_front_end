import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

enum ProfileEditStatus { initial, saving, saved, uploading, uploaded, failure }

class ProfileEditState extends Equatable {
  final ProfileEditStatus status;
  final ProfileEntity? updatedProfile;
  final String? successMessage;
  final String? errorMessage;
  final String? uploadedFileId;
  final double uploadProgress;
  final String? uploadType;

  const ProfileEditState({
    this.status = ProfileEditStatus.initial,
    this.updatedProfile,
    this.successMessage,
    this.errorMessage,
    this.uploadedFileId,
    this.uploadProgress = 0.0,
    this.uploadType,
  });

  ProfileEditState copyWith({
    ProfileEditStatus? status,
    ProfileEntity? updatedProfile,
    String? successMessage,
    String? errorMessage,
    String? uploadedFileId,
    double? uploadProgress,
    String? uploadType,
  }) {
    return ProfileEditState(
      status: status ?? this.status,
      updatedProfile: updatedProfile ?? this.updatedProfile,
      successMessage: successMessage,
      errorMessage: errorMessage,
      uploadedFileId: uploadedFileId ?? this.uploadedFileId,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadType: uploadType ?? this.uploadType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        updatedProfile,
        successMessage,
        errorMessage,
        uploadedFileId,
        uploadProgress,
        uploadType,
      ];
}
