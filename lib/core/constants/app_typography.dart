import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => TextTheme(
        displayLarge: _display1,
        displayMedium: _display2,
        displaySmall: _display3,
        headlineLarge: _headline1,
        headlineMedium: _headline2,
        headlineSmall: _headline3,
        titleLarge: _title1,
        titleMedium: _title2,
        titleSmall: _title3,
        bodyLarge: _body1,
        bodyMedium: _body2,
        bodySmall: _body3,
        labelLarge: _label1,
        labelMedium: _label2,
        labelSmall: _label3,
      );

  // Display
  static TextStyle get _display1 => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.charcoal,
        height: 1.1,
        letterSpacing: 0,
      );

  static TextStyle get _display2 => GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.charcoal,
        height: 1.15,
        letterSpacing: 0,
      );

  static TextStyle get _display3 => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
        height: 1.2,
        letterSpacing: 0,
      );

  // Headline
  static TextStyle get _headline1 => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
        height: 1.25,
        letterSpacing: 0,
      );

  static TextStyle get _headline2 => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
        height: 1.3,
        letterSpacing: 0,
      );

  static TextStyle get _headline3 => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.charcoal,
        height: 1.35,
        letterSpacing: 0,
      );

  // Title
  static TextStyle get _title1 => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        height: 1.4,
        letterSpacing: 0,
      );

  static TextStyle get _title2 => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        height: 1.4,
        letterSpacing: 0,
      );

  static TextStyle get _title3 => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        height: 1.45,
        letterSpacing: 0,
      );

  // Body
  static TextStyle get _body1 => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
        height: 1.6,
        letterSpacing: 0,
      );

  static TextStyle get _body2 => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
        height: 1.6,
        letterSpacing: 0,
      );

  static TextStyle get _body3 => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.5,
        letterSpacing: 0,
      );

  // Label
  static TextStyle get _label1 => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        height: 1.4,
        letterSpacing: 0,
      );

  static TextStyle get _label2 => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        height: 1.4,
        letterSpacing: 0,
      );

  static TextStyle get _label3 => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.mutedText,
        height: 1.4,
        letterSpacing: 0,
      );

  // Convenience getters
  static TextStyle get displayBold => _display1;
  static TextStyle get displayMedium => _display2;

  static TextStyle get headingLg => _headline1;
  static TextStyle get headingMd => _headline2;
  static TextStyle get headingSm => _headline3;

  static TextStyle get titleLg => _title1;
  static TextStyle get titleMd => _title2;
  static TextStyle get titleSm => _title3;

  static TextStyle get bodyLg => _body1;
  static TextStyle get bodyMd => _body2;
  static TextStyle get bodySm => _body3;

  static TextStyle get labelLg => _label1;
  static TextStyle get labelMd => _label2;
  static TextStyle get labelSm => _label3;

  static TextStyle get caption => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
        height: 1.4,
        letterSpacing: 0,
      );

  static TextStyle get overline => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedText,
        letterSpacing: 0,
        height: 1.4,
      );

  static TextStyle get buttonText => GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
      );

  static TextStyle get navLabel => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      );
}
