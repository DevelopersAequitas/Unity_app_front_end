import 'package:equatable/equatable.dart';

class CircleCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? circleKey;
  final int level;
  final int sortOrder;
  final bool isActive;
  final int memberCount;
  final int childLevel2Count;
  final int childLevel3Count;
  final int childLevel4Count;
  final String? iconUrl;

  const CircleCategoryEntity({
    required this.id,
    required this.name,
    this.slug,
    this.circleKey,
    this.level = 1,
    this.sortOrder = 0,
    this.isActive = true,
    this.memberCount = 0,
    this.childLevel2Count = 0,
    this.childLevel3Count = 0,
    this.childLevel4Count = 0,
    this.iconUrl,
  });

  String get formattedMemberCount {
    if (memberCount >= 1000) {
      final k = (memberCount / 1000).toStringAsFixed(1);
      return '${k.endsWith('.0') ? k.substring(0, k.length - 2) : k}K members';
    }
    return '$memberCount members';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        circleKey,
        level,
        sortOrder,
        isActive,
        memberCount,
        childLevel2Count,
        childLevel3Count,
        childLevel4Count,
        iconUrl,
      ];
}
