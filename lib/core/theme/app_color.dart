import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Brand Colors
  static const Color primaryBlue = Color(0xFF1D4ED8);
  static const Color primaryPink = Color(0xFFE11D48);

  // Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFFE11D48)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Subtle screen background gradient (top → bottom, barely visible)
  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F4FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF12141A), Color(0xFF181C27)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light Palette
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightSurfaceMuted = Color(0xFFF8FAFC);
  static const Color lightScaffoldBg = Color(0xFFF6F9FD);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF334155);
  static const Color lightTextDisabled = Color(0xFF94A3B8);
  static const Color badgeBlueBg = Color(0xFFEFF6FF);
  static const Color badgePinkBg = Color(0xFFFFF1F2);

  // Dark Palette
  static const Color darkBackground = Color(0xFF12141A);
  static const Color darkSurface = Color(0xFF1E222D);
  static const Color darkSurfaceSubtle = Color(0xFF242938);
  static const Color darkBorder = Color(0xFF2A2F3D);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextDisabled = Color(0xFF64748B);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color black = Color(0xFF000000);

  // Design Tokens Aliases
  static const Color primary = primaryBlue;
  static const Color primaryGradientEnd = primaryPink;
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textTertiary = lightTextDisabled;
  static const Color borderSubtle = lightBorder;
  static const Color background = lightScaffoldBg;
  static const Color backgroundSubtle = lightSurfaceSubtle;
}

