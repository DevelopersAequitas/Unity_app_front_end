import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/utils/app_date_formatter.dart';
import 'package:unity_app/core/utils/app_error_handler.dart';
import '../../../domain/usecases/get_events_usecase.dart';
import '../../../domain/usecases/get_register_visitor_submissions_usecase.dart';
import '../../../domain/usecases/submit_register_visitor_usecase.dart';
import 'register_visitor_event.dart';
import 'register_visitor_state.dart';

class RegisterVisitorBloc
    extends Bloc<RegisterVisitorEvent, RegisterVisitorState> {
  final SubmitRegisterVisitorUseCase submitRegisterVisitorUseCase;
  final GetRegisterVisitorSubmissionsUseCase getRegisterVisitorSubmissionsUseCase;
  final GetEventsUseCase getEventsUseCase;

  RegisterVisitorBloc({
    required this.submitRegisterVisitorUseCase,
    required this.getRegisterVisitorSubmissionsUseCase,
    required this.getEventsUseCase,
  }) : super(const RegisterVisitorState()) {
    on<FetchRegisterVisitorHistoryEvent>(_onFetchHistory);
    on<SubmitRegisterVisitorEvent>(_onSubmit);
    on<FetchEventsEvent>(_onFetchEvents);
  }

  Future<void> _onFetchHistory(
    FetchRegisterVisitorHistoryEvent event,
    Emitter<RegisterVisitorState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(state.copyWith(status: RegisterVisitorStatus.loading));
    }
    try {
      final submissions = await getRegisterVisitorSubmissionsUseCase();
      emit(state.copyWith(
        status: RegisterVisitorStatus.success,
        submissions: submissions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterVisitorStatus.failure,
        errorMessage: AppErrorHandler.getDisplayMessage(e),
      ));
    }
  }

  Future<void> _onSubmit(
    SubmitRegisterVisitorEvent event,
    Emitter<RegisterVisitorState> emit,
  ) async {
    emit(state.copyWith(status: RegisterVisitorStatus.submitting));
    try {
      await submitRegisterVisitorUseCase(event.entity);
      emit(state.copyWith(
        status: RegisterVisitorStatus.success,
        successMessage: 'Visitor registered successfully!',
      ));
      add(const FetchRegisterVisitorHistoryEvent(isRefresh: true));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterVisitorStatus.failure,
        errorMessage: AppErrorHandler.getDisplayMessage(e),
      ));
    }
  }

  Future<void> _onFetchEvents(
    FetchEventsEvent event,
    Emitter<RegisterVisitorState> emit,
  ) async {
    if (!event.isRefresh && state.eventsStatus == RegisterVisitorStatus.initial) {
      emit(state.copyWith(eventsStatus: RegisterVisitorStatus.loading));
    }
    try {
      final allEvents = await getEventsUseCase();
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final futureEvents = allEvents.where((e) {
        final parsed = AppDateFormatter.parseUtc(e.startDate) ?? AppDateFormatter.parseUtc(e.startAt);
        if (parsed == null) return true;
        return parsed.isAfter(todayStart) || parsed.isAtSameMomentAs(todayStart);
      }).toList();
      emit(state.copyWith(
        eventsStatus: RegisterVisitorStatus.success,
        events: futureEvents.isNotEmpty ? futureEvents : allEvents,
      ));
    } catch (e) {
      emit(state.copyWith(eventsStatus: RegisterVisitorStatus.failure));
    }
  }
}
