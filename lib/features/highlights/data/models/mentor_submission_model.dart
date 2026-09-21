import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/mentor_submission_entity.dart';

class MentorSubmissionModel extends MentorSubmissionEntity {
  const MentorSubmissionModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.city,
    required super.linkedinProfile,
    super.status,
    super.createdAt,
  });

  factory MentorSubmissionModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = AppDateFormatter.parseUtc(json['created_at']);

    return MentorSubmissionModel(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      linkedinProfile: (json['linkedin_profile'] ??
              json['linkedin_url'] ??
              json['linkedin_profile_url'] ??
              '')
          .toString(),
      status: json['status']?.toString(),
      createdAt: parsedDate,
    );
  }

  factory MentorSubmissionModel.fromEntity(MentorSubmissionEntity entity) {
    return MentorSubmissionModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      city: entity.city,
      linkedinProfile: entity.linkedinProfile,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'linkedin_profile': linkedinProfile,
      'linkedin_url': linkedinProfile,
      'linkedin_profile_url': linkedinProfile,
    };
  }
}
