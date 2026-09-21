import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/check_payment_status_usecase.dart';
import '../../domain/usecases/get_event_detail_usecase.dart';
import '../../domain/usecases/register_event_usecase.dart';
import '../../domain/usecases/register_visitor_event_usecase.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventDetailUseCase getEventDetailUseCase;
  final RegisterEventUseCase registerEventUseCase;
  final RegisterVisitorEventUseCase registerVisitorEventUseCase;
  final CheckPaymentStatusUseCase checkPaymentStatusUseCase;

  EventDetailBloc({
    required this.getEventDetailUseCase,
    required this.registerEventUseCase,
    required this.registerVisitorEventUseCase,
    required this.checkPaymentStatusUseCase,
  }) : super(const EventDetailState()) {
    on<LoadEventDetailEvent>(_onLoadDetail);
    on<AttendEventEvent>(_onAttendEvent);
    on<RegisterVisitorEventEvent>(_onRegisterVisitor);
    on<PollPaymentStatusEvent>(_onPollPaymentStatus);
  }

  Future<void> _onLoadDetail(
    LoadEventDetailEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    final isDifferentEvent = state.event?.eventId != event.eventId ||
        state.event?.occurrenceId != event.occurrenceId ||
        (state.registration != null &&
            state.registration?.occurrenceId != null &&
            state.registration!.occurrenceId != event.occurrenceId);

    if (!event.isRefresh) {
      emit(state.copyWith(
        status: EventDetailStatus.loading,
        clearRegistration: isDifferentEvent,
      ));
    }
    try {
      final detail = await getEventDetailUseCase(
        eventId: event.eventId,
        occurrenceId: event.occurrenceId,
      );
      emit(state.copyWith(
        status: EventDetailStatus.success,
        event: detail,
        clearRegistration: isDifferentEvent,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EventDetailStatus.failure,
        errorMessage: AppErrorHandler.toUserFriendlyMessage(e),
      ));
    }
  }

  Future<void> _onAttendEvent(
    AttendEventEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(state.copyWith(status: EventDetailStatus.registering));
    try {
      final reg = await registerEventUseCase(
        eventId: event.eventId,
        occurrenceId: event.occurrenceId,
        couponCode: event.couponCode,
        reason: event.reason,
        categoryId: event.categoryId,
      );
      final isPaid = reg.paymentRequired && reg.paymentUrl != null;
      final isPending = reg.isPendingApproval;
      emit(state.copyWith(
        status: isPaid
            ? EventDetailStatus.paymentRequired
            : (isPending ? EventDetailStatus.success : EventDetailStatus.registered),
        registration: reg,
        successMessage: isPaid
            ? 'Please complete payment'
            : (isPending
                ? (reg.eventTitle ?? 'Registration request submitted for admin approval.')
                : 'Registration confirmed!'),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EventDetailStatus.failure,
        errorMessage: AppErrorHandler.toUserFriendlyMessage(e),
      ));
    }
  }

  Future<void> _onRegisterVisitor(
    RegisterVisitorEventEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(state.copyWith(status: EventDetailStatus.registering));
    try {
      final reg = await registerVisitorEventUseCase(
        eventId: event.eventId,
        occurrenceId: event.occurrenceId,
        visitorData: event.visitorData,
        couponCode: event.couponCode,
      );
      final isPaid = reg.paymentRequired && reg.paymentUrl != null;
      final isPending = reg.isPendingApproval;
      emit(state.copyWith(
        status: isPaid
            ? EventDetailStatus.paymentRequired
            : (isPending ? EventDetailStatus.success : EventDetailStatus.registered),
        registration: reg,
        successMessage: isPaid
            ? 'Please complete payment'
            : (isPending
                ? (reg.eventTitle ?? 'Registration request submitted for admin approval.')
                : 'Registration confirmed!'),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EventDetailStatus.failure,
        errorMessage: AppErrorHandler.toUserFriendlyMessage(e),
      ));
    }
  }

  Future<void> _onPollPaymentStatus(
    PollPaymentStatusEvent event,
    Emitter<EventDetailState> emit,
  ) async {
    try {
      final updated = await checkPaymentStatusUseCase(event.registrationId);
      if (updated.isConfirmed) {
        emit(state.copyWith(
          status: EventDetailStatus.registered,
          registration: updated,
          successMessage: 'Payment verified! Attendance confirmed.',
        ));
      } else {
        emit(state.copyWith(registration: updated));
      }
    } catch (_) {}
  }
}
