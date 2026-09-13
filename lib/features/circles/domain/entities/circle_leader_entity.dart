import 'package:equatable/equatable.dart';

class CircleLeaderEntity extends Equatable {
  final String id;
  final String name;
  final String role;
  final String? avatarUrl;
  final String? designation;
  final String? companyName;
  final String? leaderType; // 'circle' or 'regional'
  final String? region;

  const CircleLeaderEntity({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.designation,
    this.companyName,
    this.leaderType,
    this.region,
  });

  String get effectiveRole => designation != null && designation!.isNotEmpty ? designation! : role;

  @override
  List<Object?> get props => [id, name, role, avatarUrl, designation, companyName, leaderType, region];
}

