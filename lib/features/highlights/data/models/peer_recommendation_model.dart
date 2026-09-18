import '../../domain/entities/peer_recommendation_entity.dart';

class PeerRecommendationModel extends PeerRecommendationEntity {
  const PeerRecommendationModel({
    required super.peerName,
    required super.peerMobile,
    super.peerEmail,
    super.peerCityCountry,
    super.peerBusiness,
    super.peerCategory,
    super.peerIndustry,
    required super.howWellKnown,
    required super.isAware,
    super.whyValuable,
    super.note,
  });

  factory PeerRecommendationModel.fromEntity(PeerRecommendationEntity entity) {
    return PeerRecommendationModel(
      peerName: entity.peerName,
      peerMobile: entity.peerMobile,
      peerEmail: entity.peerEmail,
      peerCityCountry: entity.peerCityCountry,
      peerBusiness: entity.peerBusiness,
      peerCategory: entity.peerCategory,
      peerIndustry: entity.peerIndustry,
      howWellKnown: entity.howWellKnown,
      isAware: entity.isAware,
      whyValuable: entity.whyValuable,
      note: entity.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peer_name': peerName,
      'peer_mobile': peerMobile,
      if (peerEmail != null && peerEmail!.isNotEmpty) 'peer_email': peerEmail,
      if (peerCityCountry != null && peerCityCountry!.isNotEmpty) 'peer_city_country': peerCityCountry,
      if (peerBusiness != null && peerBusiness!.isNotEmpty) 'peer_business': peerBusiness,
      if (peerCategory != null && peerCategory!.isNotEmpty) 'peer_category': peerCategory,
      if (peerIndustry != null && peerIndustry!.isNotEmpty) 'peer_industry': peerIndustry,
      'how_well_known': howWellKnown,
      'is_aware': isAware,
      if (whyValuable != null && whyValuable!.isNotEmpty) 'why_valuable': whyValuable,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}
