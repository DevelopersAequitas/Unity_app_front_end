import 'package:equatable/equatable.dart';

class AskLeaderboardItemModel extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int count;
  final String giverBadge;
  final int rank;
  final String? companyName;
  final String? city;
  final String flowCode;

  const AskLeaderboardItemModel({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.count,
    required this.giverBadge,
    required this.rank,
    this.companyName,
    this.city,
    this.flowCode = 'help',
  });

  factory AskLeaderboardItemModel.fromJson(
    Map<String, dynamic> json, {
    String flowCode = 'help',
  }) {
    final user = json['user'] is Map ? json['user'] as Map<String, dynamic> : null;
    final id = json['user_id']?.toString() ??
        user?['id']?.toString() ??
        json['id']?.toString() ??
        '';
    final name = json['display_name']?.toString() ??
        user?['display_name']?.toString() ??
        json['name']?.toString() ??
        'Peer';
    final avatar = json['avatar_url']?.toString() ??
        user?['avatar_url']?.toString() ??
        user?['profile_photo_url']?.toString() ??
        json['avatar']?.toString();
    final badge = json['giver_badge']?.toString() ??
        json['badge']?.toString() ??
        json['badge_text']?.toString() ??
        'Active Contributor';
    final rankVal = int.tryParse(json['rank']?.toString() ?? '') ?? 1;

    final countVal = int.tryParse(json['help_rendered_count']?.toString() ?? '') ??
        int.tryParse(json['collaborations_count']?.toString() ?? '') ??
        int.tryParse(json['referrals_count']?.toString() ?? '') ??
        int.tryParse(json['count']?.toString() ?? '') ??
        int.tryParse(json['score']?.toString() ?? '') ??
        0;

    final company = json['company_name']?.toString() ??
        user?['company_name']?.toString() ??
        json['company']?.toString();
    final cityVal = json['city']?.toString() ??
        user?['city']?.toString() ??
        user?['location']?.toString();

    return AskLeaderboardItemModel(
      userId: id,
      displayName: name,
      avatarUrl: avatar,
      count: countVal,
      giverBadge: badge,
      rank: rankVal,
      companyName: company,
      city: cityVal,
      flowCode: flowCode,
    );
  }

  String get metricLabel {
    final c = flowCode.toLowerCase();
    if (c == 'collaboration') {
      return '$count Collab${count == 1 ? '' : 's'}';
    } else if (c == 'referral') {
      return '$count Intro${count == 1 ? '' : 's'}';
    } else {
      return '$count Help Rendered';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatarUrl,
        count,
        giverBadge,
        rank,
        companyName,
        city,
        flowCode,
      ];
}
