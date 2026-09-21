import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_support_tickets_usecase.dart';
import '../../domain/usecases/submit_ticket_usecase.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetSupportTicketsUseCase getSupportTicketsUseCase;
  final SubmitTicketUseCase submitTicketUseCase;

  SupportBloc({
    required this.getSupportTicketsUseCase,
    required this.submitTicketUseCase,
  }) : super(const SupportState()) {
    on<SupportTicketsFetchRequested>(_onFetchTickets);
    on<SupportTicketSubmitRequested>(_onSubmitTicket);
  }

  Future<void> _onFetchTickets(
    SupportTicketsFetchRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(status: SupportStatus.loading));
    try {
      final tickets = await getSupportTicketsUseCase();
      emit(state.copyWith(
        status: SupportStatus.success,
        tickets: tickets,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SupportStatus.failure,
        errorMessage: 'Failed to load support tickets.',
      ));
    }
  }

  Future<void> _onSubmitTicket(
    SupportTicketSubmitRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, submitSuccess: false));
    try {
      await submitTicketUseCase(
        subject: event.subject,
        description: event.description,
        department: event.department,
        priority: event.priority,
        mediaFileId: event.mediaFileId,
      );
      emit(state.copyWith(
        isSubmitting: false,
        submitSuccess: true,
        errorMessage: null,
      ));
      add(const SupportTicketsFetchRequested());
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        submitSuccess: false,
        errorMessage: 'Failed to submit ticket. Please try again.',
      ));
    }
  }
}
