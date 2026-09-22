import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_file_usecase.dart';
import 'profile_bloc.dart';
import 'profile_edit_event.dart';
import 'profile_edit_state.dart';
import 'profile_event.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfileMediaUseCase uploadFileUseCase;
  final ProfileBloc profileBloc;

  ProfileEditBloc({
    required this.updateProfileUseCase,
    required this.uploadFileUseCase,
    required this.profileBloc,
  }) : super(const ProfileEditState()) {
    on<ProfileSaveSectionRequested>(_onSaveSectionRequested);
    on<ProfileUploadPhotoRequested>(_onUploadPhotoRequested);
    on<ProfileUploadVideoRequested>(_onUploadVideoRequested);
    on<ProfileUploadProgressUpdated>(_onUploadProgressUpdated);
    on<ProfileEditResetRequested>(_onResetRequested);
  }

  void _onResetRequested(
    ProfileEditResetRequested event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(const ProfileEditState());
  }

  void _onUploadProgressUpdated(
    ProfileUploadProgressUpdated event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(state.copyWith(uploadProgress: event.progress));
  }

  Future<void> _onSaveSectionRequested(
    ProfileSaveSectionRequested event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(status: ProfileEditStatus.saving, errorMessage: null));
    try {
      final updatedProfile = await updateProfileUseCase(event.updateData);
      profileBloc.add(ProfileLocallyUpdated(updatedProfile));
      emit(state.copyWith(
        status: ProfileEditStatus.saved,
        updatedProfile: updatedProfile,
        successMessage: '${event.sectionName} updated successfully!',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileEditStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUploadPhotoRequested(
    ProfileUploadPhotoRequested event,
    Emitter<ProfileEditState> emit,
  ) async {
    final mediaLabel = event.isCover ? 'Cover Banner' : 'Profile Photo';
    emit(state.copyWith(
      status: ProfileEditStatus.uploading,
      uploadProgress: 0.0,
      uploadType: mediaLabel,
      errorMessage: null,
    ));
    try {
      final fileId = await uploadFileUseCase(
        event.file,
        onProgress: (progress) {
          if (!isClosed) {
            add(ProfileUploadProgressUpdated(progress));
          }
        },
      );
      final updateKey = event.isCover ? 'cover_photo_id' : 'profile_photo_id';
      final updatedProfile = await updateProfileUseCase({updateKey: fileId});
      profileBloc.add(ProfileLocallyUpdated(updatedProfile));
      emit(state.copyWith(
        status: ProfileEditStatus.uploaded,
        uploadProgress: 1.0,
        updatedProfile: updatedProfile,
        uploadedFileId: fileId,
        successMessage: '$mediaLabel updated successfully!',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileEditStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUploadVideoRequested(
    ProfileUploadVideoRequested event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(
      status: ProfileEditStatus.uploading,
      uploadProgress: 0.0,
      uploadType: 'Profile Video',
      errorMessage: null,
    ));
    try {
      final fileId = await uploadFileUseCase(
        event.file,
        onProgress: (progress) {
          if (!isClosed) {
            add(ProfileUploadProgressUpdated(progress));
          }
        },
      );
      final updatedProfile = await updateProfileUseCase({'profile_video_id': fileId});
      profileBloc.add(ProfileLocallyUpdated(updatedProfile));
      emit(state.copyWith(
        status: ProfileEditStatus.uploaded,
        uploadProgress: 1.0,
        updatedProfile: updatedProfile,
        uploadedFileId: fileId,
        successMessage: 'Profile video updated successfully!',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileEditStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
