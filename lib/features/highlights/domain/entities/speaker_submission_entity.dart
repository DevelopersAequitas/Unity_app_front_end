class SpeakerSubmissionEntity {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String company;
  final String designation;
  final String topicExpertise;
  final String linkedinProfile;
  final String? briefBio;
  final String? imageUrl;
  final String? status;
  final DateTime? createdAt;

  const SpeakerSubmissionEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.company,
    required this.designation,
    required this.topicExpertise,
    required this.linkedinProfile,
    this.briefBio,
    this.imageUrl,
    this.status,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
}
