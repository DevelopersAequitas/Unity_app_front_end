import 'package:equatable/equatable.dart';
import '../../../domain/entities/introduced_peer_entity.dart';
import '../../../domain/entities/top_builder_entity.dart';

enum TopBuildersStatus { initial, loading, success, failure }

class TopBuildersState extends Equatable {
  final TopBuildersStatus status;
  final List<TopBuilderEntity> topBuilders;
  final List<IntroducedPeerEntity> myIntroduced;
  final String searchQuery;
  final String? errorMessage;

  const TopBuildersState({
    this.status = TopBuildersStatus.initial,
    this.topBuilders = const [],
    this.myIntroduced = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  List<TopBuilderEntity> get filteredTopBuilders {
    if (searchQuery.trim().isEmpty) return topBuilders;
    final q = searchQuery.toLowerCase();
    return topBuilders.where((b) {
      return b.name.toLowerCase().contains(q) ||
          b.company.toLowerCase().contains(q) ||
          b.designation.toLowerCase().contains(q) ||
          b.city.toLowerCase().contains(q);
    }).toList();
  }

  List<IntroducedPeerEntity> get filteredMyIntroduced {
    if (searchQuery.trim().isEmpty) return myIntroduced;
    final q = searchQuery.toLowerCase();
    return myIntroduced.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.businessName.toLowerCase().contains(q) ||
        p.designation.toLowerCase().contains(q) ||
        p.city.toLowerCase().contains(q)).toList();
  }

  TopBuildersState copyWith({
    TopBuildersStatus? status,
    List<TopBuilderEntity>? topBuilders,
    List<IntroducedPeerEntity>? myIntroduced,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TopBuildersState(
      status: status ?? this.status,
      topBuilders: topBuilders ?? this.topBuilders,
      myIntroduced: myIntroduced ?? this.myIntroduced,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, topBuilders, myIntroduced, searchQuery, errorMessage];
}
