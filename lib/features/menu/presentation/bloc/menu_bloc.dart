import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_menu_summary_usecase.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuSummaryUseCase getMenuSummaryUseCase;

  MenuBloc({required this.getMenuSummaryUseCase}) : super(const MenuState()) {
    on<MenuFetchSummaryRequested>(_onFetchSummary);
    on<MenuRefreshSummaryRequested>(_onRefreshSummary);
  }

  Future<void> _onFetchSummary(
    MenuFetchSummaryRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final summary = await getMenuSummaryUseCase();
      emit(state.copyWith(
        status: MenuStatus.success,
        summary: summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MenuStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshSummary(
    MenuRefreshSummaryRequested event,
    Emitter<MenuState> emit,
  ) async {
    try {
      final summary = await getMenuSummaryUseCase();
      emit(state.copyWith(
        status: MenuStatus.success,
        summary: summary,
      ));
    } catch (_) {
      // Keep existing state on silent refresh
    }
  }
}
