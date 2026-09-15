import 'package:equatable/equatable.dart';

abstract class HighlightsEvent extends Equatable {
  const HighlightsEvent();

  @override
  List<Object?> get props => [];
}

class HighlightsFetchRequested extends HighlightsEvent {
  const HighlightsFetchRequested();
}

class HighlightsRefreshRequested extends HighlightsEvent {
  const HighlightsRefreshRequested();
}

class HighlightsSearchChanged extends HighlightsEvent {
  final String query;

  const HighlightsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
