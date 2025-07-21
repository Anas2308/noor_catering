import 'package:flutter/material.dart';

/// App-weite Konstanten für Farben, Stile und Werte
class AppConstants {
  // ===== FARBEN =====
  static const Color primaryGreen = Color(0xFF335B41);
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // ===== EINHEITEN =====
  static const List<String> units = [
    'kg', 'g', 'Liter', 'ml', 'Stück', 'Bund', 'Packung', 'Dose', 'Flasche'
  ];

  // ===== MÄRKTE =====
  static const List<String> stores = ['REWE', 'Edeka', 'Lidl'];

  // ===== STYLE KONSTANTEN =====
  static const double borderRadius = 12.0;
  static const double borderWidth = 2.0;
  static const double shadowBlur = 8.0;
  static const double padding = 16.0;

  // ===== TEXT STYLES =====
  static const TextStyle goldTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryGold,
    letterSpacing: 1.2,
  );

  static const TextStyle whiteText = TextStyle(
    fontSize: 16,
    color: white,
  );

  static const TextStyle greyHint = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}

/// Box Decoration Presets
class AppDecorations {
  static BoxDecoration goldBorder({Color? backgroundColor}) => BoxDecoration(
    color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    border: Border.all(
      color: AppConstants.primaryGold,
      width: AppConstants.borderWidth,
    ),
    boxShadow: [
      BoxShadow(
        color: AppConstants.primaryGold.withValues(alpha: 0.2),
        blurRadius: AppConstants.shadowBlur,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration categoryBorder(Color categoryColor) => BoxDecoration(
    color: Colors.black.withValues(alpha: 0.3),
    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    border: Border.all(
      color: categoryColor,
      width: AppConstants.borderWidth,
    ),
    boxShadow: [
      BoxShadow(
        color: categoryColor.withValues(alpha: 0.2),
        blurRadius: AppConstants.shadowBlur,
        offset: const Offset(0, 2),
      ),
    ],
  );
}