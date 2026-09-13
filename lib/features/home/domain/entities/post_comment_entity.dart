import 'package:equatable/equatable.dart';

class PostCommentEntity extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? profilePhotoUrl;
  final String? designation;
  final String? companyName;
  final String? category;
  final String? city;
  final String content;
  final String createdAt;

  const PostCommentEntity({
    required this.id,
    required this.userId,
    required this.displayName,
    this.profilePhotoUrl,
    this.designation,
    this.companyName,
    this.category,
    this.city,
    required this.content,
    this.createdAt = '',
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        profilePhotoUrl,
        designation,
        companyName,
        category,
        city,
        content,
        createdAt,
      ];
}
