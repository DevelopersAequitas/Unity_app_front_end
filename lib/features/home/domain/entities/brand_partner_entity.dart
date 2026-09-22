import 'package:equatable/equatable.dart';

class BrandPartnerEntity extends Equatable {
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

  const BrandPartnerEntity({
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

  @override
  List<Object?> get props => [
    id, name, slug, logoUrl, coverImageUrl, shortDescription, description,
    websiteUrl, contactEmail, contactNumber, whatsapp, address,
    offerTitle, offerDescription, couponCode, discountType, discountValue,
    validFrom, validTo, termsAndConditions,
    isFeatured, isSponsored, isVerified,
  ];
}
