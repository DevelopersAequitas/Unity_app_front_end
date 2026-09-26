import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_match_peer_entity.dart';

enum AskMatchesStatus { initial, loading, loaded, error }

class AskMatchesState extends Equatable {
  final AskMatchesStatus status;
  final List<AskMatchPeerEntity> matches;
  final String? errorMessage;

  const AskMatchesState({
    this.status = AskMatchesStatus.initial,
    this.matches = const [],
    this.errorMessage,
  });

  AskMatchesState copyWith({
    AskMatchesStatus? status,
    List<AskMatchPeerEntity>? matches,
    String? errorMessage,
  }) {
    return AskMatchesState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, errorMessage];
}
