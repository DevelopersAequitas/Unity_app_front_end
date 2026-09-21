import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/get_my_events_with_qr_usecase.dart';
import 'my_events_event.dart';
import 'my_events_state.dart';

class MyEventsBloc extends Bloc<MyEventsEvent, MyEventsState> {
  final GetMyEventsWithQrUseCase getMyEventsWithQrUseCase;

  MyEventsBloc({required this.getMyEventsWithQrUseCase})
      : super(const MyEventsState()) {
    on<FetchMyEventsEvent>(_onFetchMyEvents);
    on<ChangeMyEventsTabEvent>(_onChangeTab);
  }

  Future<void> _onFetchMyEvents(
    FetchMyEventsEvent event,
    Emitter<MyEventsState> emit,
  ) async {
    if (!event.isRefresh && state.status != MyEventsStatus.success) {
      emit(state.copyWith(status: MyEventsStatus.loading));
    }
    try {
      final items = await getMyEventsWithQrUseCase();
      emit(state.copyWith(
        status: MyEventsStatus.success,
        allItems: items,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyEventsStatus.failure,
        errorMessage: AppErrorHandler.toUserFriendlyMessage(e),
      ));
    }
  }

  void _onChangeTab(
    ChangeMyEventsTabEvent event,
    Emitter<MyEventsState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }
}
