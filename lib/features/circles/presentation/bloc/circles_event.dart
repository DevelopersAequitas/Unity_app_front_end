import 'package:equatable/equatable.dart';

abstract class CirclesEvent extends Equatable {
  const CirclesEvent();

  @override
  List<Object?> get props => [];
}

class CirclesFetchRequested extends CirclesEvent {
  const CirclesFetchRequested();
}

class CirclesRefreshRequested extends CirclesEvent {
  const CirclesRefreshRequested();
}

class CirclesTabChanged extends CirclesEvent {
  final int tabIndex;
  const CirclesTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class CirclesSearchChanged extends CirclesEvent {
  final String query;
  const CirclesSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CircleDetailRequested extends CirclesEvent {
  final String circleId;
  const CircleDetailRequested(this.circleId);

  @override
  List<Object?> get props => [circleId];
}
