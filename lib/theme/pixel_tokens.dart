import 'package:flutter/material.dart';

/// Pixel Design System tokens for monochrome grayscale palette.
/// Optimized for Dark & OLED modes with strict contrast compliance.
abstract final class PixelTokens {
  // ==================== Colors ====================
  /// Pure black background (OLED optimized)
  static const Color surfaceDarkest = Color(0xFF000000);

  /// Charcoal dark surface
  static const Color surfaceDark = Color(0xFF121212);

  /// Medium gray surface
  static const Color surfaceMedium = Color(0xFF1E1E1E);

  /// Border and divider gray
  static const Color surfaceBorder = Color(0xFF2E2E2E);

  /// Light gray surface
  static const Color surfaceLight = Color(0xFF3D3D3D);

  /// Pure white text (maximum contrast)
  static const Color textPrimary = Color(0xFFFFFFFF);

  // ==================== Contrast Ratios ====================
  /// WCAG AAA standard (≥7:1) - textPrimary vs surfaceDarkest
  static const double contrastAAA = 21.0;

  /// WCAG AA standard (≥4.5:1) - textPrimary vs surfaceLight
  static const double contrastAA = 12.6;

  // ==================== Touch Targets ====================
  /// ISO 9241 minimum touch target (48.0 dp)
  static const double touchTargetMinimum = 48.0;

  // ==================== Corner Radius ====================
  /// Subtle corner radius
  static const double radiusSubtle = 12.0;

  /// Standard Pixel corner radius
  static const double radiusStandard = 20.0;

  /// Pill-shaped corner radius
  static const double radiusPill = 28.0;
}
