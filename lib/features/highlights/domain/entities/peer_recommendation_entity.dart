import 'package:equatable/equatable.dart';

class PeerRecommendationEntity extends Equatable {
  final String peerName;
  final String peerMobile;
  final String? peerEmail;
  final String? peerCityCountry;
  final String? peerBusiness;
  final String? peerCategory;
  final String? peerIndustry;
  final String howWellKnown;
  final bool isAware;
  final String? whyValuable;
  final String? note;

  const PeerRecommendationEntity({
    required this.peerName,
    required this.peerMobile,
    this.peerEmail,
    this.peerCityCountry,
    this.peerBusiness,
    this.peerCategory,
    this.peerIndustry,
    required this.howWellKnown,
    required this.isAware,
    this.whyValuable,
    this.note,
  });

  @override
  List<Object?> get props => [
        peerName,
        peerMobile,
        peerEmail,
        peerCityCountry,
        peerBusiness,
        peerCategory,
        peerIndustry,
        howWellKnown,
        isAware,
        whyValuable,
        note,
      ];
}
