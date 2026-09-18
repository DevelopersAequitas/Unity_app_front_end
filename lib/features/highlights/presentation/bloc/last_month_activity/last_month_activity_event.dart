import 'package:equatable/equatable.dart';

abstract class LastMonthActivityEvent extends Equatable {
  const LastMonthActivityEvent();

  @override
  List<Object?> get props => [];
}

class FetchLastMonthActivityEvent extends LastMonthActivityEvent {
  final bool isRefresh;
  const FetchLastMonthActivityEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}
