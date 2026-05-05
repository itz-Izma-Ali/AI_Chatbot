import 'package:flutter/material.dart';

class AppColors {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryGlow;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color userBubble;
  final Color aiBubble;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryGlow,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.userBubble,
    required this.aiBubble,
  });

  static const light = AppColors(
    primary: Color(0xFF6366F1),
    primaryDark: Color(0xFF4F46E5),
    primaryLight: Color(0xFF818CF8),
    primaryGlow: Color(0x666366F1),
    secondary: Color(0xFF10B981),
    background: Color(0xFFF9FAFB),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    border: Color(0xFFE5E7EB),
    userBubble: Color(0xFF6366F1),
    aiBubble: Color(0xFFF3F4F6),
  );

  static const dark = AppColors(
    primary: Color(0xFF818CF8),
    primaryDark: Color(0xFF6366F1),
    primaryLight: Color(0xFFA5B4FC),
    primaryGlow: Color(0x4D818CF8),
    secondary: Color(0xFF34D399),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    border: Color(0xFF334155),
    userBubble: Color(0xFF6366F1),
    aiBubble: Color(0xFF334155),
  );
}

extension AppColorsContext on BuildContext {
  AppColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  }
}
