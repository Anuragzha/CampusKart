import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF2563EB); // Modern Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Dark Navy for center Sell FAB and headers
  static const Color navy = Color(0xFF192238);
  static const Color navyLight = Color(0xFF283452);

  // Background and Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBorder = Color(0xFFF1F5F9);

  // Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Badges from design mockup
  static const Color featured = Color(0xFFF59E0B);
  static const Color usedBadgeBg = Color(0xFFEEF2FF);
  static const Color usedBadgeText = Color(0xFF4338CA);
  static const Color newBadgeBg = Color(0xFFECFDF5);
  static const Color newBadgeText = Color(0xFF047857);
  static const Color buyingBadgeBg = Color(0xFFDCFCE7);
  static const Color buyingBadgeText = Color(0xFF15803D);
  static const Color sellingBadgeBg = Color(0xFFFEF3C7);
  static const Color sellingBadgeText = Color(0xFFB45309);

  // Functional Status
  static const Color success = Color(0xFF10B981);
  static const Color successSurface = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFEF4444);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color cardShadow = Color(0x0D000000);
  static const Color negotiableBadge = Color(0xFF10B981);
  static const Color verifiedBadge = Color(0xFF2563EB);

  // Legacy aliases
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFCCFBF1);
  static const Color slate = Color(0xFF334155);
  static const Color blue = Color(0xFF2563EB);
}
