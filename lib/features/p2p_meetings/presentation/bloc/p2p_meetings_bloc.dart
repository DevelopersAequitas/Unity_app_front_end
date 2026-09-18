import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/accept_p2p_meeting_request_usecase.dart';
import '../../domain/usecases/approve_reschedule_request_usecase.dart';
import '../../domain/usecases/cancel_p2p_meeting_request_usecase.dart';
import '../../domain/usecases/get_p2p_meeting_requests_inbox_usecase.dart';
import '../../domain/usecases/get_p2p_meeting_requests_sent_usecase.dart';
import '../../domain/usecases/get_p2p_meetings_history_usecase.dart';
import '../../domain/usecases/get_pending_reschedule_requests_received_usecase.dart';
import '../../domain/usecases/reject_p2p_meeting_request_usecase.dart';
import '../../domain/usecases/reject_reschedule_request_usecase.dart';
import '../../domain/usecases/request_reschedule_p2p_meeting_usecase.dart';
import 'p2p_meetings_event.dart';
import 'p2p_meetings_state.dart';

class P2pMeetingsBloc extends Bloc<P2pMeetingsEvent, P2pMeetingsState> {
  final GetP2pMeetingsHistoryUseCase getP2pMeetingsHistoryUseCase;
  final GetP2pMeetingRequestsInboxUseCase getP2pMeetingRequestsInboxUseCase;
  final GetP2pMeetingRequestsSentUseCase getP2pMeetingRequestsSentUseCase;
  final GetPendingRescheduleRequestsReceivedUseCase
      getPendingRescheduleRequestsReceivedUseCase;
  final AcceptP2pMeetingRequestUseCase acceptP2pMeetingRequestUseCase;
  final RejectP2pMeetingRequestUseCase rejectP2pMeetingRequestUseCase;
  final CancelP2pMeetingRequestUseCase cancelP2pMeetingRequestUseCase;
  final ApproveRescheduleRequestUseCase approveRescheduleRequestUseCase;
  final RejectRescheduleRequestUseCase rejectRescheduleRequestUseCase;
  final RequestRescheduleP2pMeetingUseCase requestRescheduleP2pMeetingUseCase;

  P2pMeetingsBloc({
    required this.getP2pMeetingsHistoryUseCase,
    required this.getP2pMeetingRequestsInboxUseCase,
    required this.getP2pMeetingRequestsSentUseCase,
    required this.getPendingRescheduleRequestsReceivedUseCase,
    required this.acceptP2pMeetingRequestUseCase,
    required this.rejectP2pMeetingRequestUseCase,
    required this.cancelP2pMeetingRequestUseCase,
    required this.approveRescheduleRequestUseCase,
    required this.rejectRescheduleRequestUseCase,
    required this.requestRescheduleP2pMeetingUseCase,
  }) : super(const P2pMeetingsState()) {
    on<P2pMeetingsFetchRequested>(_onFetchRequested);
    on<P2pMeetingsRefreshRequested>(_onRefreshRequested);
    on<P2pMeetingsTopTabChanged>((e, emit) => emit(state.copyWith(topTab: e.topTab)));
    on<P2pMeetingsCompletedSubTabChanged>((e, emit) => emit(state.copyWith(completedSubTab: e.subTab)));
    on<P2pMeetingsScheduledSubTabChanged>((e, emit) => emit(state.copyWith(scheduledSubTab: e.subTab)));
    on<P2pMeetingsSearchChanged>((e, emit) => emit(state.copyWith(searchQuery: e.query)));
    on<P2pMeetingAcceptRequested>(_onAcceptRequested);
    on<P2pMeetingRejectRequested>(_onRejectRequested);
    on<P2pMeetingCancelRequested>(_onCancelRequested);
    on<P2pMeetingRescheduleRequested>(_onRescheduleRequested);
    on<P2pMeetingRescheduleApproved>(_onRescheduleApproved);
    on<P2pMeetingRescheduleRejected>(_onRescheduleRejected);
  }

  Future<void> _onFetchRequested(
    P2pMeetingsFetchRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    emit(state.copyWith(status: P2pMeetingsStatus.loading));
    try {
      final results = await Future.wait([
        getP2pMeetingsHistoryUseCase(filter: 'given'),
        getP2pMeetingsHistoryUseCase(filter: 'received'),
        getP2pMeetingRequestsInboxUseCase(),
        getP2pMeetingRequestsSentUseCase(),
        getPendingRescheduleRequestsReceivedUseCase(),
      ]);

      emit(state.copyWith(
        status: P2pMeetingsStatus.success,
        iInitiatedMeetings: results[0] as dynamic,
        peerInitiatedMeetings: results[1] as dynamic,
        receivedRequests: results[2] as dynamic,
        sentRequests: results[3] as dynamic,
        rescheduleRequests: results[4] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to load meetings: $e',
      ));
    }
  }

  Future<void> _onRefreshRequested(
    P2pMeetingsRefreshRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      final results = await Future.wait([
        getP2pMeetingsHistoryUseCase(filter: 'given'),
        getP2pMeetingsHistoryUseCase(filter: 'received'),
        getP2pMeetingRequestsInboxUseCase(),
        getP2pMeetingRequestsSentUseCase(),
        getPendingRescheduleRequestsReceivedUseCase(),
      ]);

      emit(state.copyWith(
        status: P2pMeetingsStatus.success,
        iInitiatedMeetings: results[0] as dynamic,
        peerInitiatedMeetings: results[1] as dynamic,
        receivedRequests: results[2] as dynamic,
        sentRequests: results[3] as dynamic,
        rescheduleRequests: results[4] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Refresh failed: $e',
      ));
    }
  }

  Future<void> _onAcceptRequested(
    P2pMeetingAcceptRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await acceptP2pMeetingRequestUseCase(event.requestId);
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Meeting invitation accepted',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to accept meeting: $e',
      ));
    }
  }

  Future<void> _onRejectRequested(
    P2pMeetingRejectRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await rejectP2pMeetingRequestUseCase(event.requestId);
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Meeting invitation declined',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to decline meeting: $e',
      ));
    }
  }

  Future<void> _onCancelRequested(
    P2pMeetingCancelRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await cancelP2pMeetingRequestUseCase(event.requestId);
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Meeting request cancelled',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to cancel meeting: $e',
      ));
    }
  }

  Future<void> _onRescheduleRequested(
    P2pMeetingRescheduleRequested event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await requestRescheduleP2pMeetingUseCase(
        event.params.meetingRequestId,
        event.params,
      );
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Reschedule request sent',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to request reschedule: $e',
      ));
    }
  }

  Future<void> _onRescheduleApproved(
    P2pMeetingRescheduleApproved event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await approveRescheduleRequestUseCase(event.rescheduleRequestId);
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Reschedule request approved',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to approve reschedule: $e',
      ));
    }
  }

  Future<void> _onRescheduleRejected(
    P2pMeetingRescheduleRejected event,
    Emitter<P2pMeetingsState> emit,
  ) async {
    try {
      await rejectRescheduleRequestUseCase(
        event.rescheduleRequestId,
        reason: event.reason,
      );
      emit(state.copyWith(
        status: P2pMeetingsStatus.actionSuccess,
        successMessage: 'Reschedule request declined',
      ));
      add(const P2pMeetingsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        status: P2pMeetingsStatus.failure,
        errorMessage: 'Failed to decline reschedule: $e',
      ));
    }
  }
}
