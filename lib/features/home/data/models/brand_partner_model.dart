import '../../domain/entities/brand_partner_entity.dart';

class BrandPartnerModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? offerTitle;
  final String? offerDescription;
  final String? shortDescription;
  final String? websiteUrl;
  final String? couponCode;
  final double? discountValue;
  final String? validTo;
  final bool isFeatured;
  final bool isSponsored;

  const BrandPartnerModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.coverImageUrl,
    this.offerTitle,
    this.offerDescription,
    this.shortDescription,
    this.websiteUrl,
    this.couponCode,
    this.discountValue,
    this.validTo,
    this.isFeatured = false,
    this.isSponsored = false,
  });

  factory BrandPartnerModel.fromJson(Map<String, dynamic> json) {
    return BrandPartnerModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['brand_name'] ?? '').toString(),
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      offerTitle: json['offer_title'] as String?,
      offerDescription: json['offer_description'] as String?,
      shortDescription: (json['short_description'] ?? json['description']) as String?,
      websiteUrl: (json['website_url'] ?? json['website']) as String?,
      couponCode: json['coupon_code'] as String?,
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      validTo: json['valid_to'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      isSponsored: json['is_sponsored'] as bool? ?? false,
    );
  }

  BrandPartnerEntity toEntity() {
    return BrandPartnerEntity(
      id: id,
      name: name,
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      offerTitle: offerTitle,
      offerDescription: offerDescription,
      shortDescription: shortDescription,
      websiteUrl: websiteUrl,
      couponCode: couponCode,
      discountValue: discountValue,
      validTo: validTo,
      isFeatured: isFeatured,
      isSponsored: isSponsored,
    );
  }
}
