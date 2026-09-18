class MentorSubmissionEntity {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String linkedinProfile;
  final String? status;
  final DateTime? createdAt;

  const MentorSubmissionEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.linkedinProfile,
    this.status,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
}
