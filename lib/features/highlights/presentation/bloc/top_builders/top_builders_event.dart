import 'package:equatable/equatable.dart';

abstract class TopBuildersEvent extends Equatable {
  const TopBuildersEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopBuildersDataEvent extends TopBuildersEvent {
  final bool isRefresh;
  const FetchTopBuildersDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SearchIntroducedPeersEvent extends TopBuildersEvent {
  final String query;
  const SearchIntroducedPeersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
