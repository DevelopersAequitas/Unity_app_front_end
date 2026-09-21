import 'package:equatable/equatable.dart';

class MessageReaderEntity extends Equatable {
  final String id;
  final String name;
  final String? companyName;
  final String? profilePhotoUrl;
  final DateTime? readAt;

  const MessageReaderEntity({
    required this.id,
    required this.name,
    this.companyName,
    this.profilePhotoUrl,
    this.readAt,
  });

  String get initials {
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    return '?';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        companyName,
        profilePhotoUrl,
        readAt,
      ];
}
