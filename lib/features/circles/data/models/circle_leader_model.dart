import '../../domain/entities/circle_leader_entity.dart';

class CircleLeaderModel extends CircleLeaderEntity {
  const CircleLeaderModel({
    required super.id,
    required super.name,
    required super.role,
    super.avatarUrl,
    super.designation,
    super.companyName,
    super.leaderType,
    super.region,
  });

  factory CircleLeaderModel.fromJson(Map<String, dynamic> json, [String? defaultType]) {
    final rawName = json['name']?.toString() ??
        json['display_name']?.toString() ??
        json['full_name']?.toString() ??
        (json['first_name'] != null
            ? '${json['first_name']} ${json['last_name'] ?? ''}'.trim()
            : 'Leader');

    final des = json['designation']?.toString();
    final r = json['role']?.toString() ?? json['role_title']?.toString() ?? des ?? 'Leader';

    return CircleLeaderModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: rawName.isEmpty ? 'Leader' : rawName,
      role: r,
      designation: des ?? r,
      companyName: json['company_name']?.toString() ?? json['company']?.toString(),
      avatarUrl: json['profile_photo_url']?.toString() ??
          json['avatar_url']?.toString() ??
          json['photo_url']?.toString() ??
          json['image_url']?.toString(),
      leaderType: json['leader_type']?.toString() ?? defaultType ?? 'circle',
      region: json['region']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'designation': designation,
      'company_name': companyName,
      'avatar_url': avatarUrl,
      'leader_type': leaderType,
      'region': region,
    };
  }
}

