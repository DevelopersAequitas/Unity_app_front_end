import '../../domain/entities/ask_item_entity.dart';

class AskItemModel {
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
  final String itemType;
  final bool isCongratulated;
  final bool isSaved;
  final String? storyText;
  final Map<String, dynamic> rawData;

  const AskItemModel({
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

  factory AskItemModel.fromJson(Map<String, dynamic> json) {
    final flowObj = json['flow'] is Map ? json['flow'] as Map<String, dynamic> : null;
    final typeObj = json['type'] is Map ? json['type'] as Map<String, dynamic> : null;

    final fCode = flowObj?['code']?.toString() ?? json['flow_code']?.toString() ?? json['flow']?.toString() ?? '';
    final fName = flowObj?['name']?.toString() ??
        json['flow_name']?.toString() ??
        (fCode == 'collaboration'
            ? 'Find a Collaborator'
            : (fCode == 'help'
                ? 'Get Help'
                : (fCode == 'referral' ? 'Ask for an Introduction' : fCode)));
    final tName = typeObj?['name']?.toString() ??
        json['category']?.toString() ??
        json['category_title']?.toString() ??
        json['type_name']?.toString() ??
        json['offering_in_return']?.toString() ??
        json['referral_type']?.toString() ??
        json['type']?.toString() ??
        'General';

    final matches = json['match_count'] ?? json['matches_count'] ?? (json['matches'] is List ? (json['matches'] as List).length : 0);
    final responses = json['response_count'] ?? json['responses_count'] ?? (json['responses'] is List ? (json['responses'] as List).length : 0);

    final sub = json['subtitle'] ?? json['latest_activity'] ?? json['activity_text'] ?? json['description'] ?? json['remarks'];
    final timeVal = json['badge_text'] ??
        json['timing'] ??
        json['timeline'] ??
        json['urgency'] ??
        json['help_timing'] ??
        (json['hot_value'] != null ? 'Hot Level ${json['hot_value']}' : null);
    final iType = json['item_type'] ?? json['post_type'] ?? (json['story_text'] != null ? 'story' : 'ask');
    final titleText = (json['title'] ?? json['referral_of'] ?? json['goal'] ?? json['content_text'] ?? '$fName - $tName').toString();
    final statusText = (json['status_label'] ?? json['status'] ?? 'open').toString();

    return AskItemModel(
      id: (json['id'] ?? json['ask_id'] ?? '').toString(),
      flowCode: fCode,
      flowName: fName.isNotEmpty ? fName : 'Ask',
      typeName: tName,
      title: titleText.isNotEmpty ? titleText : '$fName - $tName',
      status: statusText,
      matchCount: (matches is num) ? matches.toInt() : (int.tryParse(matches.toString()) ?? 0),
      responseCount: (responses is num) ? responses.toInt() : (int.tryParse(responses.toString()) ?? 0),
      visibility: (json['visibility'] ?? 'district').toString(),
      createdAt: json['created_at']?.toString(),
      subtitle: sub?.toString(),
      timing: timeVal?.toString(),
      itemType: iType.toString(),
      isCongratulated: json['is_congratulated'] == true,
      isSaved: json['is_saved'] == true || json['is_bookmarked'] == true,
      storyText: (json['story_text'] ?? (iType == 'story' || iType == 'ask_fulfilled' || iType == 'spotlight' ? json['content_text'] : null))?.toString(),
      rawData: json,
    );
  }

  AskItemEntity toEntity() {
    return AskItemEntity(
      id: id,
      flowCode: flowCode,
      flowName: flowName,
      typeName: typeName,
      title: title,
      status: status,
      matchCount: matchCount,
      responseCount: responseCount,
      visibility: visibility,
      createdAt: createdAt,
      subtitle: subtitle,
      timing: timing,
      itemType: itemType,
      isCongratulated: isCongratulated,
      isSaved: isSaved,
      storyText: storyText,
      rawData: rawData,
    );
  }
}
