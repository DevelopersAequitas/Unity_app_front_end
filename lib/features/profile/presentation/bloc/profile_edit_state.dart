import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

enum ProfileEditStatus { initial, saving, saved, uploading, uploaded, failure }

class ProfileEditState extends Equatable {
  final ProfileEditStatus status;
  final ProfileEntity? updatedProfile;
  final String? successMessage;
  final String? errorMessage;
  final String? uploadedFileId;

  const ProfileEditState({
    this.status = ProfileEditStatus.initial,
    this.updatedProfile,
    this.successMessage,
    this.errorMessage,
    this.uploadedFileId,
  });

  ProfileEditState copyWith({
    ProfileEditStatus? status,
    ProfileEntity? updatedProfile,
    String? successMessage,
    String? errorMessage,
    String? uploadedFileId,
  }) {
    return ProfileEditState(
      status: status ?? this.status,
      updatedProfile: updatedProfile ?? this.updatedProfile,
      successMessage: successMessage,
      errorMessage: errorMessage,
      uploadedFileId: uploadedFileId ?? this.uploadedFileId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        updatedProfile,
        successMessage,
        errorMessage,
        uploadedFileId,
      ];
}
