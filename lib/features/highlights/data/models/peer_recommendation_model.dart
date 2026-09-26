import '../../domain/entities/peer_recommendation_entity.dart';

class PeerRecommendationModel extends PeerRecommendationEntity {
  const PeerRecommendationModel({
    super.id,
    required super.peerName,
    required super.peerMobile,
    super.peerEmail,
    super.peerCityCountry,
    super.peerBusiness,
    super.mainCategoryId,
    super.mainCategoryName,
    super.subCategoryId,
    super.subCategoryName,
    super.peerCategory,
    super.peerIndustry,
    super.howWellKnown = 'business_associate',
    super.isAware = true,
    super.whyValuable,
    super.note,
    super.circleId,
    super.circleName,
    super.createdAt,
    super.submittedAt,
  });

  factory PeerRecommendationModel.fromEntity(PeerRecommendationEntity entity) {
    return PeerRecommendationModel(
      id: entity.id,
      peerName: entity.peerName,
      peerMobile: entity.peerMobile,
      peerEmail: entity.peerEmail,
      peerCityCountry: entity.peerCityCountry,
      peerBusiness: entity.peerBusiness,
      mainCategoryId: entity.mainCategoryId,
      mainCategoryName: entity.mainCategoryName,
      subCategoryId: entity.subCategoryId,
      subCategoryName: entity.subCategoryName,
      peerCategory: entity.peerCategory,
      peerIndustry: entity.peerIndustry,
      howWellKnown: entity.howWellKnown,
      isAware: entity.isAware,
      whyValuable: entity.whyValuable,
      note: entity.note,
      circleId: entity.circleId,
      circleName: entity.circleName,
      createdAt: entity.createdAt,
      submittedAt: entity.submittedAt,
    );
  }

  factory PeerRecommendationModel.fromJson(Map<String, dynamic> json) {
    final rawMainId = json['main_business_category_id'] ??
        json['main_category_id'] ??
        json['category_id'];
    final parsedMainId = rawMainId is int
        ? rawMainId
        : int.tryParse(rawMainId?.toString() ?? '');

    final rawSubId = json['business_subcategory_id'] ??
        json['subcategory_id'] ??
        json['sub_category_id'];

    final rawIsAware = json['is_aware'] ?? json['isAware'];
    bool parsedIsAware = true;
    if (rawIsAware is bool) {
      parsedIsAware = rawIsAware;
    } else if (rawIsAware != null) {
      final s = rawIsAware.toString().toLowerCase();
      parsedIsAware = s == 'true' || s == '1';
    }

    final createdAtStr =
        json['created_at']?.toString() ?? json['createdAt']?.toString();
    final submittedAtStr = json['submitted_at']?.toString() ??
        json['submittedAt']?.toString() ??
        createdAtStr;

    return PeerRecommendationModel(
      id: json['id']?.toString(),
      peerName: json['peer_name']?.toString() ??
          json['peerName']?.toString() ??
          json['name']?.toString() ??
          '',
      peerMobile: json['peer_mobile']?.toString() ??
          json['peerMobile']?.toString() ??
          json['mobile']?.toString() ??
          json['phone']?.toString() ??
          '',
      peerEmail: json['peer_email']?.toString() ??
          json['peerEmail']?.toString() ??
          json['email']?.toString(),
      peerCityCountry: json['peer_city_country']?.toString() ??
          json['peer_city']?.toString() ??
          json['peerCity']?.toString() ??
          json['city']?.toString(),
      peerBusiness: json['peer_business']?.toString() ??
          json['peerBusiness']?.toString() ??
          json['business']?.toString() ??
          json['company']?.toString(),
      mainCategoryId: parsedMainId,
      mainCategoryName: json['main_business_category']?.toString() ??
          json['main_category']?.toString() ??
          json['peer_category']?.toString() ??
          json['category']?.toString(),
      subCategoryId: rawSubId,
      subCategoryName: json['business_subcategory']?.toString() ??
          json['subcategory']?.toString() ??
          json['sub_category']?.toString() ??
          json['peer_subcategory']?.toString(),
      peerCategory: json['peer_category']?.toString() ??
          json['category']?.toString() ??
          json['main_business_category']?.toString(),
      peerIndustry: json['peer_industry']?.toString() ??
          json['peerIndustry']?.toString() ??
          json['industry']?.toString(),
      howWellKnown: json['how_well_known']?.toString() ??
          json['howWellKnown']?.toString() ??
          'business_associate',
      isAware: parsedIsAware,
      whyValuable: json['why_valuable']?.toString() ??
          json['whyValuable']?.toString(),
      note: json['note']?.toString(),
      circleId: json['circle_id']?.toString() ?? json['circleId']?.toString(),
      circleName: json['circle_name']?.toString() ??
          json['circleName']?.toString(),
      createdAt: createdAtStr,
      submittedAt: submittedAtStr,
    );
  }

  Map<String, dynamic> toJson() {
    final effectiveCategory = mainCategoryName ?? peerCategory;
    final effectiveSubcategory = subCategoryName;

    return {
      'peer_name': peerName,
      'peer_mobile': peerMobile,
      if (peerEmail != null && peerEmail!.isNotEmpty) 'peer_email': peerEmail,
      if (peerCityCountry != null && peerCityCountry!.isNotEmpty) ...{
        'peer_city': peerCityCountry,
        'peer_city_country': peerCityCountry,
      },
      if (peerBusiness != null && peerBusiness!.isNotEmpty)
        'peer_business': peerBusiness,
      if (effectiveCategory != null && effectiveCategory.isNotEmpty) ...{
        'main_business_category': effectiveCategory,
        'main_category': effectiveCategory,
        'peer_category': effectiveCategory,
        'category': effectiveCategory,
      },
      if (mainCategoryId != null) ...{
        'main_business_category_id': mainCategoryId,
        'main_category_id': mainCategoryId,
      },
      if (effectiveSubcategory != null && effectiveSubcategory.isNotEmpty) ...{
        'business_subcategory': effectiveSubcategory,
        'subcategory': effectiveSubcategory,
        'peer_subcategory': effectiveSubcategory,
      },
      if (subCategoryId != null) ...{
        'business_subcategory_id': subCategoryId,
        'subcategory_id': subCategoryId,
      },
      if (peerIndustry != null && peerIndustry!.isNotEmpty)
        'peer_industry': peerIndustry,
      'how_well_known': howWellKnown,
      'is_aware': isAware,
      if (whyValuable != null && whyValuable!.isNotEmpty)
        'why_valuable': whyValuable,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (circleId != null && circleId!.isNotEmpty) 'circle_id': circleId,
      if (circleName != null && circleName!.isNotEmpty)
        'circle_name': circleName,
    };
  }
}
