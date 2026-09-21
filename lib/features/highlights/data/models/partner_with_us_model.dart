import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/partner_with_us_entity.dart';

class PartnerWithUsModel extends PartnerWithUsEntity {
  const PartnerWithUsModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.mobileNumber,
    required super.emailId,
    required super.city,
    required super.brandOrCompanyName,
    required super.websiteOrSocialMediaLink,
    required super.industry,
    required super.aboutYourBusiness,
    required super.partnershipGoal,
    required super.whyPartnerWithPeersGlobal,
    super.status,
    super.createdAt,
  });

  factory PartnerWithUsModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = AppDateFormatter.parseUtc(json['created_at']);

    return PartnerWithUsModel(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      mobileNumber: (json['mobile_number'] ?? json['phone'] ?? '').toString(),
      emailId: (json['email_id'] ?? json['email'] ?? '').toString(),
      city: json['city']?.toString() ?? '',
      brandOrCompanyName: (json['brand_or_company_name'] ??
              json['company_name'] ??
              json['brand'] ??
              '')
          .toString(),
      websiteOrSocialMediaLink: (json['website_or_social_media_link'] ??
              json['website'] ??
              json['social_media_link'] ??
              '')
          .toString(),
      industry: json['industry']?.toString() ?? '',
      aboutYourBusiness: (json['about_your_business'] ?? json['about'] ?? '').toString(),
      partnershipGoal: (json['partnership_goal'] ?? '').toString(),
      whyPartnerWithPeersGlobal: (json['why_partner_with_peers_global'] ?? '').toString(),
      status: json['status']?.toString(),
      createdAt: parsedDate,
    );
  }

  factory PartnerWithUsModel.fromEntity(PartnerWithUsEntity entity) {
    return PartnerWithUsModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      mobileNumber: entity.mobileNumber,
      emailId: entity.emailId,
      city: entity.city,
      brandOrCompanyName: entity.brandOrCompanyName,
      websiteOrSocialMediaLink: entity.websiteOrSocialMediaLink,
      industry: entity.industry,
      aboutYourBusiness: entity.aboutYourBusiness,
      partnershipGoal: entity.partnershipGoal,
      whyPartnerWithPeersGlobal: entity.whyPartnerWithPeersGlobal,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'email_id': emailId,
      'city': city,
      'brand_or_company_name': brandOrCompanyName,
      'website_or_social_media_link': websiteOrSocialMediaLink,
      'industry': industry,
      'about_your_business': aboutYourBusiness,
      'partnership_goal': partnershipGoal,
      'why_partner_with_peers_global': whyPartnerWithPeersGlobal,
    };
  }
}
