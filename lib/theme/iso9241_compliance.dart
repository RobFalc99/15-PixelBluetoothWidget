import 'dart:math';
import 'package:flutter/material.dart';

/// ISO 9241 ergonomic compliance utilities for accessibility.
class Iso9241Compliance {
  /// Validates that a touch target meets minimum size requirements.
  ///
  /// Returns true if both width and height are at least 48.0 logical pixels,
  /// following iOS and Android accessibility guidelines.
  static bool isValidTouchTarget(Size size) {
    return size.width >= 48.0 && size.height >= 48.0;
  }

  /// Calculates the contrast ratio between two colors using relative luminance.
  ///
  /// Implements WCAG 2.0 formula: (L1 + 0.05) / (L2 + 0.05)
  /// where L1 is the luminance of the lighter color and L2 is the darker.
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = _calculateRelativeLuminance(foreground);
    final bgLuminance = _calculateRelativeLuminance(background);

    final l1 = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final l2 = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (l1 + 0.05) / (l2 + 0.05);
  }

  /// Checks if a color pair meets ISO 9241 ergonomic standards.
  ///
  /// Returns true if the contrast ratio is at least 4.5:1 (WCAG AA level).
  static bool meetsIsoErgonomics(Color fg, Color bg) {
    return calculateContrastRatio(fg, bg) >= 4.5;
  }

  /// Calculates the relative luminance of a color per WCAG 2.0.
  static double _calculateRelativeLuminance(Color color) {
    final r = _linearizeRgbComponent(color.r / 255.0);
    final g = _linearizeRgbComponent(color.g / 255.0);
    final b = _linearizeRgbComponent(color.b / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearizes an sRGB color component per WCAG 2.0 specification.
  static double _linearizeRgbComponent(double component) {
    return component <= 0.03928
        ? component / 12.92
        : pow((component + 0.055) / 1.055, 2.4).toDouble();
  }
}
