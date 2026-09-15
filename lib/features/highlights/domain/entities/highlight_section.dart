import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HighlightSection extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isLocked;
  final String category;
  final String? route;

  const HighlightSection({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.icon,
    required this.accentColor,
    this.isLocked = false,
    this.category = 'Highlights',
    this.route,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        icon,
        accentColor,
        isLocked,
        category,
        route,
      ];
}
