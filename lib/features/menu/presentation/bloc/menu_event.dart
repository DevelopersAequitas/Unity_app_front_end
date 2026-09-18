import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class MenuFetchSummaryRequested extends MenuEvent {
  const MenuFetchSummaryRequested();
}

class MenuRefreshSummaryRequested extends MenuEvent {
  const MenuRefreshSummaryRequested();
}
