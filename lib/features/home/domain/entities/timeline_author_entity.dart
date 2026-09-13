import 'package:equatable/equatable.dart';

class TimelineAuthorEntity extends Equatable {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final bool isVerified;
  final String? designation;
  final String? companyName;
  final String? level4Category;

  const TimelineAuthorEntity({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.isVerified = false,
    this.designation,
    this.companyName,
    this.level4Category,
  });

  @override
  List<Object?> get props => [
    id,
    displayName,
    firstName,
    lastName,
    profilePhotoUrl,
    isVerified,
    designation,
    companyName,
    level4Category,
  ];
}
