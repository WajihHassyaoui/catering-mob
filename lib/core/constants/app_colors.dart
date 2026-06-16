import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand palette
  static const Color creamBackground = Color(0xFFFFF8ED);
  static const Color creamCanvas = Color(0xFFFFFCF7);
  static const Color softBeige = Color(0xFFF4E6D0);
  static const Color warmIvory = Color(0xFFFFFDF8);
  static const Color oat = Color(0xFFEBD9BD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color sageGreen = Color(0xFF8FAF8B);
  static const Color oliveGreen = Color(0xFF4F6F52);
  static const Color deepOlive = Color(0xFF324C35);
  static const Color terracotta = Color(0xFFC96B3C);
  static const Color burntTerracotta = Color(0xFFA85332);
  static const Color warmGold = Color(0xFFD9A441);
  static const Color charcoal = Color(0xFF263128);
  static const Color mutedText = Color(0xFF6F7A70);
  static const Color lightBorder = Color(0xFFE8DCC8);
  static const Color softBorder = Color(0xFFF0E4D1);
  static const Color successGreen = Color(0xFF6FA878);
  static const Color errorRed = Color(0xFFD86A5D);

  // Extended palette
  static const Color cardShadow = Color(0x1C263128);
  static const Color deepShadow = Color(0x29263128);
  static const Color ambientShadow = Color(0x0F263128);
  static const Color overlayDark = Color(0x80263128);
  static const Color shimmerBase = Color(0xFFEEE5D3);
  static const Color shimmerHighlight = Color(0xFFFFF8ED);
  static const Color terracottaLight = Color(0xFFF7E5D8);
  static const Color oliveLight = Color(0xFFE8F0E9);
  static const Color goldLight = Color(0xFFFBF0D9);
  static const Color sageLight = Color(0xFFE8F0E6);

  // Status Colors
  static const Color statusPending = Color(0xFFD9A441);
  static const Color statusActive = Color(0xFF6FA878);
  static const Color statusCancelled = Color(0xFFD86A5D);
  static const Color statusDraft = Color(0xFF8FAF8B);
  static const Color statusConfirmed = Color(0xFF4F6F52);
  static const Color statusDelivered = Color(0xFF4F6F52);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepOlive, oliveGreen, sageGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [burntTerracotta, terracotta, warmGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient creamGradient = LinearGradient(
    colors: [creamBackground, softBeige],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF263D2B), deepOlive, oliveGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [warmIvory, Color(0xFFFFF6E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient foodImageGradient = LinearGradient(
    colors: [Color(0xFFFAE3C8), Color(0xFFF4B886), Color(0xFF8FAF8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
