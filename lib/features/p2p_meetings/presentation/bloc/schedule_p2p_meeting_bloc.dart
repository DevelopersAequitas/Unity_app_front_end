import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_p2p_meeting_request_params.dart';
import '../../domain/usecases/send_p2p_meeting_request_usecase.dart';
import 'schedule_p2p_meeting_event.dart';
import 'schedule_p2p_meeting_state.dart';

class ScheduleP2pMeetingBloc
    extends Bloc<ScheduleP2pMeetingEvent, ScheduleP2pMeetingState> {
  final SendP2pMeetingRequestUseCase sendP2pMeetingRequestUseCase;

  ScheduleP2pMeetingBloc({
    required this.sendP2pMeetingRequestUseCase,
  }) : super(const ScheduleP2pMeetingState()) {
    on<ScheduleP2pMeetingPeerSelected>(
        (e, emit) => emit(state.copyWith(selectedPeer: e.peer)));
    on<ScheduleP2pMeetingDateTimeChanged>(
        (e, emit) => emit(state.copyWith(scheduledAt: e.dateTime)));
    on<ScheduleP2pMeetingPlaceChanged>(
        (e, emit) => emit(state.copyWith(place: e.place)));
    on<ScheduleP2pMeetingMessageChanged>(
        (e, emit) => emit(state.copyWith(message: e.message)));
    on<ScheduleP2pMeetingSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ScheduleP2pMeetingSubmitted event,
    Emitter<ScheduleP2pMeetingState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: ScheduleP2pMeetingStatus.submitting));
    try {
      final params = CreateP2pMeetingRequestParams(
        toUserId: state.selectedPeer!.id,
        scheduledAt: state.scheduledAt,
        place: state.place.trim(),
        message: state.message.trim().isNotEmpty ? state.message.trim() : null,
      );

      final request = await sendP2pMeetingRequestUseCase(params);

      emit(state.copyWith(
        status: ScheduleP2pMeetingStatus.success,
        createdRequest: request,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ScheduleP2pMeetingStatus.failure,
        errorMessage: 'Failed to send meeting invite: $e',
      ));
    }
  }
}
