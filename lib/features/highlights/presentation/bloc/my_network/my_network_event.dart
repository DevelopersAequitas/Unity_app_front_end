import 'package:equatable/equatable.dart';

abstract class MyNetworkEvent extends Equatable {
  const MyNetworkEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyNetworkDataEvent extends MyNetworkEvent {
  final bool isRefresh;
  const FetchMyNetworkDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class GenerateInviteCodeEvent extends MyNetworkEvent {
  const GenerateInviteCodeEvent();
}
