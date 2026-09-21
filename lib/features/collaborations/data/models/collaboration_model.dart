import '../../domain/entities/collaboration.dart';
import 'collaboration_type_model.dart';
import 'industry_model.dart';

class CollaborationModel extends Collaboration {
  const CollaborationModel({
    required super.id,
    required super.collaborationType,
    required super.title,
    required super.description,
    required super.scope,
    super.countriesOfInterest,
    super.preferredModel,
    super.industry,
    required super.businessStage,
    required super.yearsInOperation,
    required super.urgency,
    required super.status,
    required super.completionStatus,
    super.completedAt,
    super.acceptedAt,
    super.acceptedBy,
    required super.postedAt,
    required super.postedDaysAgo,
    required super.expiresAt,
    required super.memberType,
    required super.isVerified,
    required super.user,
  });

  factory CollaborationModel.fromJson(Map<String, dynamic> json) {
    return CollaborationModel(
      id: json['id']?.toString() ?? '',
      collaborationType: json['collaboration_type'] is Map<String, dynamic>
          ? CollaborationTypeModel.fromJson(json['collaboration_type'])
          : CollaborationTypeModel(
              id: json['collaboration_type_id']?.toString() ?? '',
              label: json['collaboration_type_label']?.toString() ?? 'Collaboration',
            ),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      scope: json['scope']?.toString() ?? '',
      countriesOfInterest: (json['countries_of_interest'] as List?)?.map((e) => e.toString()).toList(),
      preferredModel: json['preferred_model']?.toString(),
      industry: json['industry'] is Map<String, dynamic> ? IndustryModel.fromJson(json['industry']) : null,
      businessStage: json['business_stage']?.toString() ?? '',
      yearsInOperation: json['years_in_operation']?.toString() ?? '',
      urgency: json['urgency']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      completionStatus: json['completion_status']?.toString() ?? 'incomplete',
      completedAt: json['completed_at']?.toString(),
      acceptedAt: json['accepted_at']?.toString(),
      acceptedBy: json['accepted_by'] is Map<String, dynamic>
          ? CollaborationAcceptedByModel.fromJson(json['accepted_by'])
          : null,
      postedAt: json['posted_at']?.toString() ?? json['created_at']?.toString() ?? '',
      postedDaysAgo: (json['posted_days_ago'] as num?)?.toDouble() ?? 0.0,
      expiresAt: json['expires_at']?.toString() ?? '',
      memberType: json['member_type']?.toString() ?? '',
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      user: json['user'] is Map<String, dynamic>
          ? CollaborationUserModel.fromJson(json['user'])
          : const CollaborationUserModel(id: '', name: 'Peer Member', city: ''),
    );
  }
}

class CollaborationUserModel extends CollaborationUser {
  const CollaborationUserModel({
    required super.id,
    required super.name,
    required super.city,
    super.profilePhotoUrl,
  });

  factory CollaborationUserModel.fromJson(Map<String, dynamic> json) {
    return CollaborationUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['display_name']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      profilePhotoUrl: json['profile_photo_url']?.toString() ?? json['avatar_url']?.toString(),
    );
  }
}

class CollaborationAcceptedByModel extends CollaborationAcceptedBy {
  const CollaborationAcceptedByModel({
    required super.id,
    required super.name,
    super.firstName,
    super.lastName,
    super.email,
    super.phone,
    super.companyName,
    super.designation,
    super.city,
    super.profilePhotoUrl,
  });

  factory CollaborationAcceptedByModel.fromJson(Map<String, dynamic> json) {
    return CollaborationAcceptedByModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      companyName: json['company_name']?.toString(),
      designation: json['designation']?.toString(),
      city: json['city']?.toString(),
      profilePhotoUrl: json['profile_photo_url']?.toString(),
    );
  }
}
