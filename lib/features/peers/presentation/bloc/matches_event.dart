import 'package:equatable/equatable.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object?> get props => [];
}

class MatchesFetchRequested extends MatchesEvent {
  const MatchesFetchRequested();
}

class MatchPassRequested extends MatchesEvent {
  final String peerId;
  const MatchPassRequested(this.peerId);

  @override
  List<Object?> get props => [peerId];
}

class MatchConnectRequested extends MatchesEvent {
  final String peerId;
  const MatchConnectRequested(this.peerId);

  @override
  List<Object?> get props => [peerId];
}

class MatchRemoved extends MatchesEvent {
  final String peerId;
  const MatchRemoved(this.peerId);

  @override
  List<Object?> get props => [peerId];
}
