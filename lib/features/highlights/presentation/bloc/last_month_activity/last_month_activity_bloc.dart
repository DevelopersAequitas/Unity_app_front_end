import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_last_month_activity_usecase.dart';
import 'last_month_activity_event.dart';
import 'last_month_activity_state.dart';

class LastMonthActivityBloc extends Bloc<LastMonthActivityEvent, LastMonthActivityState> {
  final GetLastMonthActivityUseCase getLastMonthActivityUseCase;

  LastMonthActivityBloc({
    required this.getLastMonthActivityUseCase,
  }) : super(const LastMonthActivityState()) {
    on<FetchLastMonthActivityEvent>(_onFetchActivity);
  }

  Future<void> _onFetchActivity(
    FetchLastMonthActivityEvent event,
    Emitter<LastMonthActivityState> emit,
  ) async {
    if (!event.isRefresh && state.status == LastMonthActivityStatus.initial) {
      emit(state.copyWith(status: LastMonthActivityStatus.loading));
    }
    try {
      final activity = await getLastMonthActivityUseCase();
      emit(state.copyWith(
        status: LastMonthActivityStatus.success,
        activity: activity,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LastMonthActivityStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
