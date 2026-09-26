import 'package:equatable/equatable.dart';

class AskItemEntity extends Equatable {
  final String id;
  final String flowCode;
  final String flowName;
  final String typeName;
  final String title;
  final String status;
  final int matchCount;
  final int responseCount;
  final String visibility;
  final String? createdAt;
  final String? subtitle;
  final String? timing;
  final String itemType; // 'ask', 'story', 'spotlight', 'ask_fulfilled'
  final bool isCongratulated;
  final bool isSaved;
  final String? storyText;
  final Map<String, dynamic> rawData;

  const AskItemEntity({
    required this.id,
    required this.flowCode,
    required this.flowName,
    required this.typeName,
    required this.title,
    required this.status,
    this.matchCount = 0,
    this.responseCount = 0,
    this.visibility = 'district',
    this.createdAt,
    this.subtitle,
    this.timing,
    this.itemType = 'ask',
    this.isCongratulated = false,
    this.isSaved = false,
    this.storyText,
    this.rawData = const {},
  });

  bool get isOpen => status.toLowerCase() == 'open' || status.toLowerCase() == 'published';
  bool get isInProgress => status.toLowerCase() == 'in_progress';
  bool get isFulfilled =>
      status.toLowerCase() == 'fulfilled' ||
      status.toLowerCase() == 'completed' ||
      status.toLowerCase().contains('got_the_business') ||
      status.toLowerCase().contains('got things done') ||
      status.toLowerCase().contains('got_things_done');
  bool get isClosed =>
      status.toLowerCase() == 'closed' ||
      status.toLowerCase() == 'cancelled' ||
      status.toLowerCase().contains('did_not_get') ||
      status.toLowerCase().contains('not a good fit') ||
      status.toLowerCase().contains('not_a_good_fit') ||
      status.toLowerCase().contains('confidential');
  bool get isExpired => status.toLowerCase() == 'expired';

  int get referralStatusId {
    if (rawData['status_id'] is num) {
      return (rawData['status_id'] as num).toInt();
    }
    return int.tryParse(rawData['status_id']?.toString() ?? '') ?? 0;
  }

  bool get isReferralFinalStatus {
    if (rawData['is_status_updated'] == true) return true;
    final sid = referralStatusId;
    if (sid >= 2 && sid <= 8) return true;
    final label = statusLabel.toLowerCase().trim();
    if (label.isNotEmpty &&
        label != 'not contacted yet' &&
        label != 'not_contacted_yet' &&
        label != 'open' &&
        label != 'published' &&
        label != 'pending') {
      return true;
    }
    return isFulfilled || isClosed;
  }

  String get authorId {
    final a = rawData['author'] ?? rawData['from_user'];
    if (a is Map) return (a['id'] ?? a['user_id'] ?? '').toString();
    return (rawData['user_id'] ?? rawData['creator_id'] ?? '').toString();
  }

  String get authorName {
    final a = rawData['author'] ?? rawData['from_user'];
    if (a is Map) return (a['display_name'] ?? a['name'] ?? '').toString();
    return '';
  }

  String? get authorAvatar {
    final a = rawData['author'] ?? rawData['from_user'];
    if (a is Map) return a['avatar_url']?.toString();
    return null;
  }

  String get authorCompany {
    final a = rawData['author'] ?? rawData['from_user'];
    if (a is Map) return (a['company_name'] ?? a['company'] ?? '').toString();
    return '';
  }

  String get authorCity {
    final a = rawData['author'] ?? rawData['from_user'];
    if (a is Map) return (a['city'] ?? '').toString();
    return '';
  }

  String get toUserId {
    final t = rawData['to_user'] ?? rawData['recipient'];
    if (t is Map) return (t['id'] ?? t['user_id'] ?? '').toString();
    return '';
  }

  String get toUserName {
    final t = rawData['to_user'] ?? rawData['recipient'];
    if (t is Map) return (t['display_name'] ?? t['name'] ?? '').toString();
    return '';
  }

  String? get toUserAvatar {
    final t = rawData['to_user'] ?? rawData['recipient'];
    if (t is Map) return t['avatar_url']?.toString();
    return null;
  }

  String get toUserCompany {
    final t = rawData['to_user'] ?? rawData['recipient'];
    if (t is Map) return (t['company_name'] ?? t['company'] ?? '').toString();
    return '';
  }

  String get toUserCity {
    final t = rawData['to_user'] ?? rawData['recipient'];
    if (t is Map) return (t['city'] ?? '').toString();
    return '';
  }

  String get description => (rawData['description'] ?? subtitle ?? '').toString();
  String get remarks => (rawData['remarks'] ?? '').toString();
  String get category => (rawData['category'] ?? typeName).toString();
  String get referralOf => (rawData['referral_of'] ?? '').toString();
  String get offeringInReturn => (rawData['offering_in_return'] ?? '').toString();
  String get referralType => (rawData['referral_type'] ?? '').toString();
  String get statusLabel => (rawData['status_label'] ?? status).toString();
  int get hotValue => (rawData['hot_value'] is num) ? (rawData['hot_value'] as num).toInt() : (int.tryParse(rawData['hot_value']?.toString() ?? '') ?? 0);
  String get phone => (rawData['phone'] ?? '').toString();
  String get email => (rawData['email'] ?? '').toString();
  String get address => (rawData['address'] ?? '').toString();

  String get timeAgo {
    if (createdAt == null || createdAt!.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 30) {
        return '${dt.day}/${dt.month}/${dt.year}';
      } else if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  AskItemEntity copyWith({
    String? id,
    String? flowCode,
    String? flowName,
    String? typeName,
    String? title,
    String? status,
    int? matchCount,
    int? responseCount,
    String? visibility,
    String? createdAt,
    String? subtitle,
    String? timing,
    String? itemType,
    bool? isCongratulated,
    bool? isSaved,
    String? storyText,
    Map<String, dynamic>? rawData,
  }) {
    return AskItemEntity(
      id: id ?? this.id,
      flowCode: flowCode ?? this.flowCode,
      flowName: flowName ?? this.flowName,
      typeName: typeName ?? this.typeName,
      title: title ?? this.title,
      status: status ?? this.status,
      matchCount: matchCount ?? this.matchCount,
      responseCount: responseCount ?? this.responseCount,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      subtitle: subtitle ?? this.subtitle,
      timing: timing ?? this.timing,
      itemType: itemType ?? this.itemType,
      isCongratulated: isCongratulated ?? this.isCongratulated,
      isSaved: isSaved ?? this.isSaved,
      storyText: storyText ?? this.storyText,
      rawData: rawData ?? this.rawData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        flowCode,
        flowName,
        typeName,
        title,
        status,
        matchCount,
        responseCount,
        visibility,
        createdAt,
        subtitle,
        timing,
        itemType,
        isCongratulated,
        isSaved,
        storyText,
        rawData,
      ];
}
