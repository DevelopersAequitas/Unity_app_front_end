import '../../domain/entities/brand_partner_entity.dart';

class BrandPartnerModel {
  final String id;
  final String name;
  final String? slug;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? shortDescription;
  final String? description;
  final String? websiteUrl;
  final String? contactEmail;
  final String? contactNumber;
  final String? whatsapp;
  final String? address;
  final String? offerTitle;
  final String? offerDescription;
  final String? couponCode;
  final String? discountType;
  final double? discountValue;
  final String? validFrom;
  final String? validTo;
  final String? termsAndConditions;
  final bool isFeatured;
  final bool isSponsored;
  final bool isVerified;

  const BrandPartnerModel({
    required this.id,
    required this.name,
    this.slug,
    this.logoUrl,
    this.coverImageUrl,
    this.shortDescription,
    this.description,
    this.websiteUrl,
    this.contactEmail,
    this.contactNumber,
    this.whatsapp,
    this.address,
    this.offerTitle,
    this.offerDescription,
    this.couponCode,
    this.discountType,
    this.discountValue,
    this.validFrom,
    this.validTo,
    this.termsAndConditions,
    this.isFeatured = false,
    this.isSponsored = false,
    this.isVerified = false,
  });

  factory BrandPartnerModel.fromJson(Map<String, dynamic> json) {
    return BrandPartnerModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['brand_name'] ?? '').toString(),
      slug: json['slug'] as String?,
      logoUrl: (json['logo_url'] ?? json['logo']) as String?,
      coverImageUrl: (json['cover_image_url'] ?? json['cover_image']) as String?,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      websiteUrl: (json['website_url'] ?? json['website']) as String?,
      contactEmail: json['contact_email'] as String?,
      contactNumber: json['contact_number'] as String?,
      whatsapp: json['whatsapp'] as String?,
      address: json['address'] as String?,
      offerTitle: json['offer_title'] as String?,
      offerDescription: json['offer_description'] as String?,
      couponCode: json['coupon_code'] as String?,
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      validFrom: json['valid_from'] as String?,
      validTo: json['valid_to'] as String?,
      termsAndConditions: json['terms_and_conditions'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      isSponsored: json['is_sponsored'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  BrandPartnerEntity toEntity() {
    return BrandPartnerEntity(
      id: id,
      name: name,
      slug: slug,
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      shortDescription: shortDescription,
      description: description,
      websiteUrl: websiteUrl,
      contactEmail: contactEmail,
      contactNumber: contactNumber,
      whatsapp: whatsapp,
      address: address,
      offerTitle: offerTitle,
      offerDescription: offerDescription,
      couponCode: couponCode,
      discountType: discountType,
      discountValue: discountValue,
      validFrom: validFrom,
      validTo: validTo,
      termsAndConditions: termsAndConditions,
      isFeatured: isFeatured,
      isSponsored: isSponsored,
      isVerified: isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo_url': logoUrl,
      'cover_image_url': coverImageUrl,
      'short_description': shortDescription,
      'description': description,
      'website_url': websiteUrl,
      'contact_email': contactEmail,
      'contact_number': contactNumber,
      'whatsapp': whatsapp,
      'address': address,
      'offer_title': offerTitle,
      'offer_description': offerDescription,
      'coupon_code': couponCode,
      'discount_type': discountType,
      'discount_value': discountValue,
      'valid_from': validFrom,
      'valid_to': validTo,
      'terms_and_conditions': termsAndConditions,
      'is_featured': isFeatured,
      'is_sponsored': isSponsored,
      'is_verified': isVerified,
    };
  }
}
