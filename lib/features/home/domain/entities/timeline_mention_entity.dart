import 'package:equatable/equatable.dart';

class TimelineMentionEntity extends Equatable {
  final String id;
  final String name;
  final String? username;
  final String? profilePhotoUrl;

  const TimelineMentionEntity({
    required this.id,
    required this.name,
    this.username,
    this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [id, name, username, profilePhotoUrl];
}
