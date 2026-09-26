import 'package:equatable/equatable.dart';

abstract class PeersFeedEvent extends Equatable {
  const PeersFeedEvent();

  @override
  List<Object?> get props => [];
}

class PeersFeedFetchRequested extends PeersFeedEvent {
  final String? scope;
  final bool isRefresh;

  const PeersFeedFetchRequested({
    this.scope,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [scope, isRefresh];
}

class PeersFeedCongratulateRequested extends PeersFeedEvent {
  final String askId;
  final String? comment;

  const PeersFeedCongratulateRequested({
    required this.askId,
    this.comment,
  });

  @override
  List<Object?> get props => [askId, comment];
}

class PeersFeedToggleSaveRequested extends PeersFeedEvent {
  final String askId;

  const PeersFeedToggleSaveRequested({required this.askId});

  @override
  List<Object?> get props => [askId];
}
