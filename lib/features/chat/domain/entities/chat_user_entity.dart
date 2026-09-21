import 'package:equatable/equatable.dart';

class ChatUserEntity extends Equatable {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? companyName;
  final String? leaderRole;
  final String? title;
  final bool isOnline;
  final bool isVerified;
  final bool isPro;
  final bool isTyping;
  final String? category;

  const ChatUserEntity({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.companyName,
    this.leaderRole,
    this.title,
    this.isOnline = false,
    this.isVerified = false,
    this.isPro = false,
    this.isTyping = false,
    this.category,
  });

  String get initials {
    if (firstName != null &&
        lastName != null &&
        firstName!.isNotEmpty &&
        lastName!.isNotEmpty) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (displayName.isNotEmpty) {
      final parts = displayName.trim().split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName[0].toUpperCase();
    }
    return '?';
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        firstName,
        lastName,
        profilePhotoUrl,
        companyName,
        leaderRole,
        title,
        isOnline,
        isVerified,
        isPro,
        isTyping,
        category,
      ];
}
