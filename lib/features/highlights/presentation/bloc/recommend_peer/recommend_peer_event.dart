import 'package:equatable/equatable.dart';
import '../../../domain/entities/peer_recommendation_entity.dart';

abstract class RecommendPeerEvent extends Equatable {
  const RecommendPeerEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPeerRecommendationEvent extends RecommendPeerEvent {
  final PeerRecommendationEntity recommendation;

  const SubmitPeerRecommendationEvent(this.recommendation);

  @override
  List<Object?> get props => [recommendation];
}

class FetchPeerRecommendationsHistoryEvent extends RecommendPeerEvent {
  const FetchPeerRecommendationsHistoryEvent();
}

class RefreshPeerRecommendationsHistoryEvent extends RecommendPeerEvent {
  const RefreshPeerRecommendationsHistoryEvent();
}
