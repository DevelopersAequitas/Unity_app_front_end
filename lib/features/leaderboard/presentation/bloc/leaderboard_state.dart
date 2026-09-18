import 'package:equatable/equatable.dart';
import '../../domain/entities/leaderboard_entity.dart';

enum LeaderboardStatus { initial, loading, success, failure }

class LeaderboardState extends Equatable {
  final LeaderboardStatus status;
  final LeaderboardEntity leaderboard;
  final String? errorMessage;

  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.leaderboard = const LeaderboardEntity(),
    this.errorMessage,
  });

  bool get isLoading => status == LeaderboardStatus.loading;
  bool get isSuccess => status == LeaderboardStatus.success;
  bool get isFailure => status == LeaderboardStatus.failure;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    LeaderboardEntity? leaderboard,
    String? errorMessage,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      leaderboard: leaderboard ?? this.leaderboard,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, leaderboard, errorMessage];
}
