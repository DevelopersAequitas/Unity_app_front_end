import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class CircleIconConfig {
  final IconData icon;
  final Color tintColor;
  final Color bgTint;

  const CircleIconConfig({
    required this.icon,
    required this.tintColor,
    required this.bgTint,
  });
}

class CircleIconHelper {
  CircleIconHelper._();

  static CircleIconConfig getCategoryConfig(String? name, String? key) {
    final lower = '${name ?? ''} ${key ?? ''}'.toLowerCase();

    if (lower.contains('manufactur') || lower.contains('engineer')) {
      return const CircleIconConfig(
        icon: Icons.precision_manufacturing_outlined,
        tintColor: Color(0xFFE11D48),
        bgTint: Color(0xFFFFF1F2),
      );
    }
    if (lower.contains('real estate') || lower.contains('construction') || lower.contains('infra')) {
      return const CircleIconConfig(
        icon: Icons.domain_outlined,
        tintColor: Color(0xFF8B5CF6),
        bgTint: Color(0xFFF5F3FF),
      );
    }
    if (lower.contains('tech') || lower.contains('digital') || lower.contains('it &') || lower.contains('software')) {
      return const CircleIconConfig(
        icon: Icons.computer_rounded,
        tintColor: AppColor.primaryBlue,
        bgTint: Color(0xFFEFF6FF),
      );
    }
    if (lower.contains('health') || lower.contains('wellness') || lower.contains('life sci') || lower.contains('med')) {
      return const CircleIconConfig(
        icon: Icons.spa_outlined,
        tintColor: Color(0xFF10B981),
        bgTint: Color(0xFFECFDF5),
      );
    }
    if (lower.contains('educat') || lower.contains('train') || lower.contains('skill')) {
      return const CircleIconConfig(
        icon: Icons.school_outlined,
        tintColor: Color(0xFF6366F1),
        bgTint: Color(0xFFEEF2FF),
      );
    }
    if (lower.contains('event') || lower.contains('fashion') || lower.contains('lifestyle')) {
      return const CircleIconConfig(
        icon: Icons.diamond_outlined,
        tintColor: Color(0xFFD946EF),
        bgTint: Color(0xFFFDF4FF),
      );
    }
    if (lower.contains('csr') || lower.contains('ngo') || lower.contains('nation')) {
      return const CircleIconConfig(
        icon: Icons.favorite_rounded,
        tintColor: Color(0xFFF43F5E),
        bgTint: Color(0xFFFFF1F2),
      );
    }
    if (lower.contains('franchise') || lower.contains('licens')) {
      return const CircleIconConfig(
        icon: Icons.storefront_outlined,
        tintColor: Color(0xFFF59E0B),
        bgTint: Color(0xFFFFFBEB),
      );
    }
    if (lower.contains('sustain') || lower.contains('esg') || lower.contains('green')) {
      return const CircleIconConfig(
        icon: Icons.eco_outlined,
        tintColor: Color(0xFF22C55E),
        bgTint: Color(0xFFF0FDF4),
      );
    }
    if (lower.contains('import') || lower.contains('export') || lower.contains('trade')) {
      return const CircleIconConfig(
        icon: Icons.public_rounded,
        tintColor: Color(0xFF0EA5E9),
        bgTint: Color(0xFFF0F9FF),
      );
    }
    if (lower.contains('startup') || lower.contains('founder')) {
      return const CircleIconConfig(
        icon: Icons.rocket_launch_rounded,
        tintColor: Color(0xFFE11D48),
        bgTint: Color(0xFFFFF1F2),
      );
    }
    if (lower.contains('ipo') || lower.contains('sme')) {
      return const CircleIconConfig(
        icon: Icons.bar_chart_rounded,
        tintColor: Color(0xFF8B5CF6),
        bgTint: Color(0xFFF5F3FF),
      );
    }
    if (lower.contains('investor') || lower.contains('capital') || lower.contains('finance')) {
      return const CircleIconConfig(
        icon: Icons.monetization_on_outlined,
        tintColor: Color(0xFFF59E0B),
        bgTint: Color(0xFFFFFBEB),
      );
    }
    if (lower.contains('global') || lower.contains('cross-border') || lower.contains('expansion')) {
      return const CircleIconConfig(
        icon: Icons.explore_outlined,
        tintColor: Color(0xFF06B6D4),
        bgTint: Color(0xFFECFEFF),
      );
    }
    if (lower.contains('msme') || lower.contains('entrepreneur')) {
      return const CircleIconConfig(
        icon: Icons.store_rounded,
        tintColor: Color(0xFFEC4899),
        bgTint: Color(0xFFFDF2F8),
      );
    }

    return const CircleIconConfig(
      icon: Icons.bubble_chart_outlined,
      tintColor: AppColor.primaryBlue,
      bgTint: Color(0xFFEFF6FF),
    );
  }
}
