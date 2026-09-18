import '../../domain/entities/entrepreneur_certification_result_entity.dart';

class EntrepreneurCertificationResultModel extends EntrepreneurCertificationResultEntity {
  const EntrepreneurCertificationResultModel({
    required super.id,
    required super.fullName,
    required super.businessName,
    required super.email,
    required super.contactNo,
    super.totalScore,
    super.percentage,
    super.certificationTier,
    super.status = 'new',
    super.certificateUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory EntrepreneurCertificationResultModel.fromJson(Map<String, dynamic> json) {
    int? parsedScore;
    if (json['total_score'] != null) {
      parsedScore = int.tryParse(json['total_score'].toString());
    } else if (json['score'] != null) {
      parsedScore = int.tryParse(json['score'].toString());
    }

    num? parsedPercentage;
    if (json['percentage'] != null) {
      parsedPercentage = num.tryParse(json['percentage'].toString());
    } else if (json['percent'] != null) {
      parsedPercentage = num.tryParse(json['percent'].toString());
    }

    String? certUrl;
    if (json['certificate_url'] != null) {
      certUrl = json['certificate_url']?.toString();
    } else if (json['certificate'] != null) {
      final cert = json['certificate'];
      if (cert is Map) {
        certUrl = cert['url']?.toString() ?? cert['file_url']?.toString();
      } else if (cert is String) {
        certUrl = cert;
      }
    }

    return EntrepreneurCertificationResultModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
      businessName: json['business_name']?.toString() ?? json['businessName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNo: json['contact_no']?.toString() ?? json['phone']?.toString() ?? '',
      totalScore: parsedScore,
      percentage: parsedPercentage,
      certificationTier: json['certification_tier']?.toString() ??
          json['tier']?.toString() ??
          json['certification_level']?.toString(),
      status: json['status']?.toString() ?? 'new',
      certificateUrl: certUrl,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'business_name': businessName,
      'email': email,
      'contact_no': contactNo,
      'total_score': totalScore,
      'percentage': percentage,
      'certification_tier': certificationTier,
      'status': status,
      'certificate_url': certificateUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
