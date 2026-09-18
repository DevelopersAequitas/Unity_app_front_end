import '../../domain/entities/speaker_submission_entity.dart';

class SpeakerSubmissionModel extends SpeakerSubmissionEntity {
  const SpeakerSubmissionModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.city,
    required super.company,
    required super.designation,
    required super.topicExpertise,
    required super.linkedinProfile,
    super.briefBio,
    super.imageUrl,
    super.status,
    super.createdAt,
  });

  factory SpeakerSubmissionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final createdStr = json['created_at']?.toString();
    if (createdStr != null && createdStr.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(createdStr);
      } catch (_) {}
    }

    final companyName = (json['company_name'] ??
            json['company'] ??
            json['organization'] ??
            '')
        .toString();

    final desig = (json['designation'] ??
            json['title'] ??
            json['role'] ??
            json['position'] ??
            '')
        .toString();

    final topics = (json['topics_to_speak_on'] ??
            json['topic_expertise'] ??
            json['topics'] ??
            '')
        .toString();

    return SpeakerSubmissionModel(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      company: companyName,
      designation: desig,
      topicExpertise: topics,
      linkedinProfile: (json['linkedin_profile'] ??
              json['linkedin_url'] ??
              json['linkedin_profile_url'] ??
              '')
          .toString(),
      briefBio: json['brief_bio']?.toString() ?? json['bio']?.toString(),
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString(),
      createdAt: parsedDate,
    );
  }

  factory SpeakerSubmissionModel.fromEntity(SpeakerSubmissionEntity entity) {
    return SpeakerSubmissionModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      city: entity.city,
      company: entity.company,
      designation: entity.designation,
      topicExpertise: entity.topicExpertise,
      linkedinProfile: entity.linkedinProfile,
      briefBio: entity.briefBio,
      imageUrl: entity.imageUrl,
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
      'company_name': company,
      'company': company,
      'designation': designation,
      'title': designation,
      'topics_to_speak_on': topicExpertise,
      'topic_expertise': topicExpertise,
      'linkedin_profile_url': linkedinProfile,
      'linkedin_url': linkedinProfile,
      'linkedin_profile': linkedinProfile,
      if (briefBio != null && briefBio!.isNotEmpty) 'brief_bio': briefBio,
    };
  }
}
