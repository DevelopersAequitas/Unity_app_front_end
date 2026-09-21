class Requirement {
  final String id;
  final String? postId;
  final String subject;
  final String description;
  final List<RequirementMedia> media;
  final String? cityName;
  final String? regionLabel;
  final String? category;
  final String status;
  final String submittedAt;
  final RequirementUser? user;

  const Requirement({
    required this.id,
    this.postId,
    required this.subject,
    required this.description,
    required this.media,
    this.cityName,
    this.regionLabel,
    this.category,
    required this.status,
    required this.submittedAt,
    this.user,
  });

  bool get isOpen => status.toLowerCase() == 'open';
  bool get isCompleted => status.toLowerCase() == 'completed';
}

class RequirementMedia {
  final String id;
  final String? url;

  const RequirementMedia({required this.id, this.url});
}

class RequirementUser {
  final String id;
  final String fullName;
  final String? avatar;
  final String? company;
  final String? city;

  const RequirementUser({
    required this.id,
    required this.fullName,
    this.avatar,
    this.company,
    this.city,
  });
}
