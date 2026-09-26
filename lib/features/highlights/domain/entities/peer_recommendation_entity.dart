import 'package:equatable/equatable.dart';

class PeerRecommendationEntity extends Equatable {
  final String? id;
  final String peerName;
  final String peerMobile;
  final String? peerEmail;
  final String? peerCityCountry;
  final String? peerBusiness;
  final int? mainCategoryId;
  final String? mainCategoryName;
  final dynamic subCategoryId;
  final String? subCategoryName;
  final String? peerCategory;
  final String? peerIndustry;
  final String howWellKnown;
  final bool isAware;
  final String? whyValuable;
  final String? note;
  final String? circleId;
  final String? circleName;
  final String? createdAt;
  final String? submittedAt;

  const PeerRecommendationEntity({
    this.id,
    required this.peerName,
    required this.peerMobile,
    this.peerEmail,
    this.peerCityCountry,
    this.peerBusiness,
    this.mainCategoryId,
    this.mainCategoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.peerCategory,
    this.peerIndustry,
    this.howWellKnown = 'business_associate',
    this.isAware = true,
    this.whyValuable,
    this.note,
    this.circleId,
    this.circleName,
    this.createdAt,
    this.submittedAt,
  });

  @override
  List<Object?> get props => [
        id,
        peerName,
        peerMobile,
        peerEmail,
        peerCityCountry,
        peerBusiness,
        mainCategoryId,
        mainCategoryName,
        subCategoryId,
        subCategoryName,
        peerCategory,
        peerIndustry,
        howWellKnown,
        isAware,
        whyValuable,
        note,
        circleId,
        circleName,
        createdAt,
        submittedAt,
      ];
}
