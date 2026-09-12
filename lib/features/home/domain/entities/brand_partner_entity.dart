import 'package:equatable/equatable.dart';

class BrandPartnerEntity extends Equatable {
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

  const BrandPartnerEntity({
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

  @override
  List<Object?> get props => [
    id, name, logoUrl, coverImageUrl, offerTitle, offerDescription,
    shortDescription, websiteUrl, couponCode, discountValue,
    validTo, isFeatured, isSponsored,
  ];
}
