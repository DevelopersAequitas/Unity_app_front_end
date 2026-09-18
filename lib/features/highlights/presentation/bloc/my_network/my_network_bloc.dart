import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/generate_invite_code_usecase.dart';
import '../../../domain/usecases/get_network_members_usecase.dart';
import '../../../domain/usecases/get_network_stats_usecase.dart';
import 'my_network_event.dart';
import 'my_network_state.dart';

class MyNetworkBloc extends Bloc<MyNetworkEvent, MyNetworkState> {
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkMembersUseCase getNetworkMembersUseCase;
  final GenerateInviteCodeUseCase generateInviteCodeUseCase;

  MyNetworkBloc({
    required this.getNetworkStatsUseCase,
    required this.getNetworkMembersUseCase,
    required this.generateInviteCodeUseCase,
  }) : super(const MyNetworkState()) {
    on<FetchMyNetworkDataEvent>(_onFetchData);
    on<GenerateInviteCodeEvent>(_onGenerateCode);
  }

  Future<void> _onFetchData(
    FetchMyNetworkDataEvent event,
    Emitter<MyNetworkState> emit,
  ) async {
    if (!event.isRefresh && state.status == MyNetworkStatus.initial) {
      emit(state.copyWith(status: MyNetworkStatus.loading));
    }
    try {
      final statsFuture = getNetworkStatsUseCase();
      final membersFuture = getNetworkMembersUseCase();
      final results = await Future.wait([statsFuture, membersFuture]);

      emit(state.copyWith(
        status: MyNetworkStatus.success,
        stats: results[0] as dynamic,
        members: results[1] as dynamic,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyNetworkStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGenerateCode(
    GenerateInviteCodeEvent event,
    Emitter<MyNetworkState> emit,
  ) async {
    try {
      final updatedStats = await generateInviteCodeUseCase();
      emit(state.copyWith(stats: updatedStats));
    } catch (_) {}
  }
}
