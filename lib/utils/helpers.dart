import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

/// Utility-Funktionen für die App
class AppHelpers {
  // ===== DATUM & ZEIT =====

  /// Formatiert Datum für deutsche Anzeige
  static String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  /// Formatiert Datum und Zeit für deutsche Anzeige
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  /// Gibt relative Zeit zurück (vor 2 Stunden, gestern, etc.)
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} Tag${difference.inDays == 1 ? '' : 'e'} her';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} Stunde${difference.inHours == 1 ? '' : 'n'} her';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} Minute${difference.inMinutes == 1 ? '' : 'n'} her';
    } else {
      return 'Gerade eben';
    }
  }

  // ===== PREIS FORMATIERUNG =====

  /// Formatiert Preis für deutsche Anzeige
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(2).replaceAll('.', ',')}€';
  }

  /// Parst deutschen Preis-String zu double
  static double? parseGermanPrice(String priceString) {
    // Entferne € und Leerzeichen, ersetze Komma durch Punkt
    final cleaned = priceString
        .replaceAll('€', '')
        .replaceAll(' ', '')
        .replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  // ===== STRING UTILITIES =====

  /// Kapitalisiert ersten Buchstaben
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Macht ersten Buchstaben jedes Wortes groß
  static String titleCase(String text) {
    return text.split(' ').map(capitalize).join(' ');
  }

  /// Kürzt Text ab und fügt ... hinzu
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // ===== PLURALISIERUNG =====

  /// Deutsche Pluralisierung für Zutaten
  static String pluralizeIngredients(int count) {
    return count == 1 ? 'Zutat' : 'Zutaten';
  }

  /// Deutsche Pluralisierung für Kunden
  static String pluralizeCustomers(int count) {
    return count == 1 ? 'Kunde' : 'Kunden';
  }

  /// Deutsche Pluralisierung für Rezepte
  static String pluralizeRecipes(int count) {
    return count == 1 ? 'Rezept' : 'Rezepte';
  }

  // ===== UI HELPERS =====

  /// Zeigt SnackBar mit goldenem Design
  static void showGoldSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.primaryGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Zeigt Fehler-SnackBar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Zeigt Bestätigungs-Dialog
  static Future<bool> showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Bestätigen',
        String cancelText = 'Abbrechen',
        Color? confirmColor,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: const BorderSide(
            color: AppConstants.primaryGold,
            width: AppConstants.borderWidth,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: AppConstants.primaryGold),
        ),
        content: Text(
          message,
          style: AppConstants.whiteText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: const TextStyle(color: AppConstants.primaryGold),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? AppConstants.primaryGold,
              foregroundColor: Colors.black,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ===== NAVIGATION HELPERS =====

  /// Navigiert zu Screen mit Fade-Transition
  static void navigateWithFade(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Ersetzt aktuellen Screen (kein Zurück möglich)
  static void replaceWith(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  // ===== DEVICE INFO =====

  /// Prüft ob Device ein Tablet ist
  static bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.shortestSide >= 600;
  }

  /// Gibt optimale Spaltenanzahl für Grid basierend auf Screen-Größe zurück
  static int getOptimalColumnCount(BuildContext context, {double itemWidth = 200}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - (AppConstants.padding * 2);
    final columns = (availableWidth / itemWidth).floor();
    return columns < 1 ? 1 : columns > 4 ? 4 : columns;
  }

  // ===== DEBUG HELPERS =====

  /// Debug-Print mit Zeitstempel
  static void debugLog(String message, [String? tag]) {
    final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
    final tagString = tag != null ? '[$tag] ' : '';
    debugPrint('$timestamp $tagString$message');
  }
}