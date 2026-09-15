import 'package:flutter/material.dart';
import '../../domain/entities/highlight_section.dart';

class HighlightSectionModel extends HighlightSection {
  const HighlightSectionModel({
    required super.id,
    required super.title,
    super.subtitle = '',
    required super.icon,
    required super.accentColor,
    super.isLocked,
    super.category = 'Highlights',
    super.route,
  });

  factory HighlightSectionModel.fromJson(Map<String, dynamic> json) {
    return HighlightSectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      icon: _resolveIcon(json['iconKey'] as String?),
      accentColor: Color(json['colorValue'] as int? ?? 0xFF1D4ED8),
      isLocked: json['isLocked'] as bool? ?? false,
      category: json['category'] as String? ?? 'Highlights',
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconKey': id,
      'colorValue': accentColor.toARGB32(),
      'isLocked': isLocked,
      'category': category,
      'route': route,
    };
  }

  static IconData _resolveIcon(String? iconKey) {
    switch (iconKey) {
      case 'top_community_builders':
        return Icons.emoji_events_rounded;
      case 'events':
        return Icons.event_available_rounded;
      case 'invite_friends':
        return Icons.group_add_rounded;
      case 'gratitude_script':
        return Icons.favorite_rounded;
      case 'last_month_activity':
        return Icons.insert_chart_rounded;
      case 'circle_chat':
        return Icons.chat_bubble_rounded;
      case 'open_requirement':
        return Icons.assignment_rounded;
      case 'collaborations':
        return Icons.hub_rounded;
      case 'leadership_role':
        return Icons.co_present_rounded;
      case 'recommend_peer':
        return Icons.person_add_alt_1_rounded;
      case 'become_mentor':
        return Icons.workspace_premium_rounded;
      case 'become_speaker':
        return Icons.mic_rounded;
      case 'partner_with_us':
        return Icons.handshake_rounded;
      case 'vyapaar_jagat_story':
        return Icons.auto_stories_rounded;
      case 'leadership_certificate':
        return Icons.verified_rounded;
      case 'entrepreneur_certificate':
        return Icons.military_tech_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}
