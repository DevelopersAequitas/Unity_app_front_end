import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/get_events_usecase.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEventsUseCase getEventsUseCase;

  EventsBloc({required this.getEventsUseCase}) : super(const EventsState()) {
    on<FetchAllEventsEvent>(_onFetchAllEvents);
    on<ChangeEventFilterTabEvent>(_onChangeFilterTab);
    on<SearchEventsQueryEvent>(_onSearchQuery);
  }

  Future<void> _onFetchAllEvents(
    FetchAllEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (!event.isRefresh && state.status != EventsStatus.success) {
      emit(state.copyWith(status: EventsStatus.loading));
    }
    try {
      final map = await getEventsUseCase(
        circleId: event.circleId,
      );
      emit(state.copyWith(
        status: EventsStatus.success,
        eventsMap: map,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: AppErrorHandler.toUserFriendlyMessage(e),
      ));
    }
  }

  void _onChangeFilterTab(
    ChangeEventFilterTabEvent event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(activeFilter: event.filter));
  }

  void _onSearchQuery(
    SearchEventsQueryEvent event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
