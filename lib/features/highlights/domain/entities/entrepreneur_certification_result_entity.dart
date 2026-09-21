import 'package:equatable/equatable.dart';

class EntrepreneurCertificationResultEntity extends Equatable {
  final String id;
  final String fullName;
  final String businessName;
  final String email;
  final String contactNo;
  final int? totalScore;
  final num? percentage;
  final String? certificationTier;
  final String status;
  final String? notes;
  final String? certificateUrl;
  final String? certificateDownloadUrl;
  final String? createdAt;
  final String? updatedAt;

  const EntrepreneurCertificationResultEntity({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.email,
    required this.contactNo,
    this.totalScore,
    this.percentage,
    this.certificationTier,
    this.status = 'new',
    this.notes,
    this.certificateUrl,
    this.certificateDownloadUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        businessName,
        email,
        contactNo,
        totalScore,
        percentage,
        certificationTier,
        status,
        notes,
        certificateUrl,
        certificateDownloadUrl,
        createdAt,
        updatedAt,
      ];
}
