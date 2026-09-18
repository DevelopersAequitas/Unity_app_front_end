import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leaderboard_entity.dart';
import '../../domain/usecases/get_coins_leaderboard_usecase.dart';
import '../../domain/usecases/get_impacts_leaderboard_usecase.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final GetCoinsLeaderboardUseCase? getCoinsLeaderboardUseCase;
  final GetImpactsLeaderboardUseCase? getImpactsLeaderboardUseCase;
  final LeaderboardType type;

  LeaderboardBloc({
    this.getCoinsLeaderboardUseCase,
    this.getImpactsLeaderboardUseCase,
    this.type = LeaderboardType.coins,
  }) : super(const LeaderboardState()) {
    on<LeaderboardFetchRequested>(_onFetchLeaderboard);
  }

  Future<void> _onFetchLeaderboard(
    LeaderboardFetchRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    // 1. Immediately emit cached data if available (zero waiting time on launch or offline)
    if (!event.forceRefresh && state.leaderboard.entries.isEmpty) {
      try {
        LeaderboardEntity? cached;
        if (type == LeaderboardType.impact) {
          cached = await getImpactsLeaderboardUseCase?.getCached();
        } else {
          cached = await getCoinsLeaderboardUseCase?.getCached();
        }

        if (cached != null && cached.entries.isNotEmpty) {
          emit(state.copyWith(
            status: LeaderboardStatus.success,
            leaderboard: cached,
          ));
        } else {
          emit(state.copyWith(status: LeaderboardStatus.loading));
        }
      } catch (_) {
        emit(state.copyWith(status: LeaderboardStatus.loading));
      }
    } else if (event.forceRefresh && state.leaderboard.entries.isEmpty) {
      emit(state.copyWith(status: LeaderboardStatus.loading));
    }

    // 2. Fetch fresh leaderboard data from network
    try {
      LeaderboardEntity leaderboard;
      if (type == LeaderboardType.impact) {
        if (getImpactsLeaderboardUseCase == null) {
          throw Exception('GetImpactsLeaderboardUseCase not provided');
        }
        leaderboard = await getImpactsLeaderboardUseCase!(
          forceRefresh: event.forceRefresh,
        );
      } else {
        if (getCoinsLeaderboardUseCase == null) {
          throw Exception('GetCoinsLeaderboardUseCase not provided');
        }
        leaderboard = await getCoinsLeaderboardUseCase!(
          forceRefresh: event.forceRefresh,
        );
      }

      emit(state.copyWith(
        status: LeaderboardStatus.success,
        leaderboard: leaderboard,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.leaderboard.entries.isNotEmpty
            ? LeaderboardStatus.success
            : LeaderboardStatus.failure,
        errorMessage: state.leaderboard.entries.isEmpty ? e.toString() : null,
      ));
    }
  }
}

