import 'package:equatable/equatable.dart';

class TimelineCollaborationEntity extends Equatable {
  final String id;
  final String name;
  final String? companyName;
  final String? city;
  final String? avatarUrl;
  final bool isVerified;

  const TimelineCollaborationEntity({
    required this.id,
    required this.name,
    this.companyName,
    this.city,
    this.avatarUrl,
    this.isVerified = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    companyName,
    city,
    avatarUrl,
    isVerified,
  ];
}
