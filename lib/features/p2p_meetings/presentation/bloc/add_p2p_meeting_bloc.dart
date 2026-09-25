import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../profile/domain/usecases/upload_file_usecase.dart';
import '../../domain/entities/create_p2p_meeting_params.dart';
import '../../domain/usecases/log_p2p_meeting_usecase.dart';
import '../../domain/usecases/upload_activity_creative_usecase.dart';
import 'add_p2p_meeting_event.dart';
import 'add_p2p_meeting_state.dart';

class AddP2pMeetingBloc extends Bloc<AddP2pMeetingEvent, AddP2pMeetingState> {
  final LogP2pMeetingUseCase logP2pMeetingUseCase;
  final UploadActivityCreativeUseCase? uploadActivityCreativeUseCase;
  final UploadProfileMediaUseCase? uploadFileUseCase;

  AddP2pMeetingBloc({
    required this.logP2pMeetingUseCase,
    this.uploadActivityCreativeUseCase,
    this.uploadFileUseCase,
  }) : super(const AddP2pMeetingState()) {
    on<AddP2pMeetingPeerSelected>((e, emit) => emit(state.copyWith(selectedPeer: e.peer)));
    on<AddP2pMeetingDateChanged>((e, emit) => emit(state.copyWith(meetingDate: e.date)));
    on<AddP2pMeetingPlaceChanged>((e, emit) => emit(state.copyWith(meetingPlace: e.place)));
    on<AddP2pMeetingRemarksChanged>((e, emit) => emit(state.copyWith(remarks: e.remarks)));
    on<AddP2pMeetingPhotoSelected>((e, emit) => emit(state.copyWith(photoFile: e.photo)));
    on<AddP2pMeetingCreativeSelected>((e, emit) => emit(state.copyWith(creativeImage: e.creativeImage)));
    on<AddP2pMeetingRequestIdChanged>((e, emit) => emit(state.copyWith(meetingRequestId: e.requestId)));
    on<AddP2pMeetingSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    AddP2pMeetingSubmitted event,
    Emitter<AddP2pMeetingState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: AddP2pMeetingStatus.submitting));
    try {
      final mediaFileIds = <String>[];
      final File? creative = event.creativeImage ?? state.creativeImage;

      // ── Step 1: Upload Media File (User Photo OR Creative Fallback) ──
      if (uploadFileUseCase != null) {
        if (state.photoFile != null) {
          // Case A: User uploaded their own photo (camera / gallery)
          try {
            final uploadRes = await uploadFileUseCase!(state.photoFile!);
            if (uploadRes.isNotEmpty) {
              mediaFileIds.add(uploadRes);
            }
          } catch (e) {
            debugPrint('⚠️ Error uploading user photo: $e');
          }
        } else if (creative != null) {
          // Case B: No user photo -> Upload generated creative card as timeline post media
          try {
            final uploadRes = await uploadFileUseCase!(creative);
            if (uploadRes.isNotEmpty) {
              mediaFileIds.add(uploadRes);
            }
          } catch (e) {
            debugPrint('⚠️ Error uploading creative card as media: $e');
          }
        }
      }

      // ── Step 2: Submit meeting to /activities/p2p-meetings ──
      final params = CreateP2pMeetingParams(
        peerUserId: state.selectedPeer!.id,
        peerName: state.selectedPeer!.displayName,
        meetingDate: state.meetingDate,
        meetingPlace: state.meetingPlace.trim(),
        remarks: state.remarks.trim(),
        mediaFileIds: mediaFileIds, // Now always populated with valid file_id
        p2pMeetingRequestId: state.meetingRequestId,
      );

      final meeting = await logP2pMeetingUseCase(params);

      // ── Step 3: Register creative card in /activity-creatives ──
      if (creative != null && uploadActivityCreativeUseCase != null) {
        try {
          final activityId = meeting.id;
          final postId = meeting.postId ?? meeting.id;
          await uploadActivityCreativeUseCase!(
            activityId: activityId,
            postId: postId,
            creativeImage: creative,
          );
        } catch (e) {
          debugPrint('⚠️ Error uploading activity creative: $e');
        }
      }

      emit(state.copyWith(
        status: AddP2pMeetingStatus.success,
        createdMeeting: meeting,
      ));
      PeersEventBus.instance.emit(const PeersSyncNeededEvent());
    } catch (e) {
      String msg = e.toString();
      if (msg.startsWith('Exception: ')) {
        msg = msg.substring(11);
      }
      emit(state.copyWith(
        status: AddP2pMeetingStatus.failure,
        errorMessage: msg,
      ));
    }
  }
}
