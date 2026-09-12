import 'package:equatable/equatable.dart';
import '../../domain/entities/match_peer_entity.dart';

enum MatchesStatus { initial, loading, success, failure }

class MatchesState extends Equatable {
  final MatchesStatus status;
  final List<MatchPeerEntity> matches;
  final int currentIndex;
  final String? errorMessage;

  const MatchesState({
    this.status = MatchesStatus.initial,
    this.matches = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  MatchPeerEntity? get currentMatch =>
      (currentIndex >= 0 && currentIndex < matches.length)
          ? matches[currentIndex]
          : null;

  MatchesState copyWith({
    MatchesStatus? status,
    List<MatchPeerEntity>? matches,
    int? currentIndex,
    String? errorMessage,
  }) {
    return MatchesState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, currentIndex, errorMessage];
}
