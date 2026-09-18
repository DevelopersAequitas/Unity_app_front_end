import 'package:equatable/equatable.dart';

abstract class CoinsEvent extends Equatable {
  const CoinsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinsWalletEvent extends CoinsEvent {
  final bool isRefresh;
  const FetchCoinsWalletEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}
