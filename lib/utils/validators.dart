/// Validator-Funktionen für Formulare
class Validators {
  // ===== ALLGEMEINE VALIDATOREN =====

  /// Prüft ob ein Feld ausgefüllt ist
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return 'Bitte geben Sie ${fieldName ?? 'einen Wert'} ein';
    }
    return null;
  }

  /// Prüft ob ein Name gültig ist (min. 2 Zeichen)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bitte geben Sie einen Namen ein';
    }
    if (value.trim().length < 2) {
      return 'Name muss mindestens 2 Zeichen lang sein';
    }
    return null;
  }

  /// Prüft ob eine Telefonnummer das richtige Format hat
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bitte geben Sie eine Telefonnummer ein';
    }

    // Einfache Validierung: mindestens 5 Ziffern
    final phoneRegex = RegExp(r'[\d\s\+\-\(\)]{5,}');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Bitte geben Sie eine gültige Telefonnummer ein';
    }
    return null;
  }

  // ===== PREIS VALIDATOREN =====

  /// Prüft ob ein Preis gültig ist
  static String? price(String? value, [bool required = false]) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return 'Bitte geben Sie einen Preis ein';
      }
      return null; // Optional
    }

    // Komma durch Punkt ersetzen für deutsche Eingabe
    final normalizedValue = value.trim().replaceAll(',', '.');
    final price = double.tryParse(normalizedValue);

    if (price == null) {
      return 'Bitte geben Sie eine gültige Zahl ein';
    }

    if (price < 0) {
      return 'Preis kann nicht negativ sein';
    }

    if (price > 999.99) {
      return 'Preis kann nicht über 999.99€ sein';
    }

    return null;
  }

  /// Preis mit Marktname-Abhängigkeit
  static String? conditionalPrice({
    required String? priceValue,
    required String? storeNameValue,
    required String storeLabel,
  }) {
    final hasStoreName = storeNameValue != null && storeNameValue.trim().isNotEmpty;
    final hasPriceValue = priceValue != null && priceValue.trim().isNotEmpty;

    // Wenn Marktname eingegeben, muss auch Preis eingegeben werden
    if (hasStoreName && !hasPriceValue) {
      return 'Preis für $storeLabel fehlt';
    }

    // Wenn Preis eingegeben, normale Preis-Validierung
    if (hasPriceValue) {
      return price(priceValue, false);
    }

    return null;
  }

  // ===== ZUTATEN VALIDATOREN =====

  /// Prüft ob ein Zutatenname gültig ist
  static String? ingredientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bitte geben Sie einen Zutatennamen ein';
    }
    if (value.trim().length < 2) {
      return 'Zutatenname muss mindestens 2 Zeichen lang sein';
    }
    if (value.trim().length > 50) {
      return 'Zutatenname kann maximal 50 Zeichen lang sein';
    }
    return null;
  }

  /// Prüft ob Notizen die richtige Länge haben
  static String? notes(String? value) {
    if (value != null && value.length > 500) {
      return 'Notizen können maximal 500 Zeichen lang sein';
    }
    return null;
  }

  // ===== KOMBINIERTE VALIDATOREN =====

  /// Kombiniert mehrere Validatoren
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // ===== HELPER FUNKTIONEN =====

  /// Normalisiert Preis-String (Komma zu Punkt)
  static double? parsePrice(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  /// Formatiert Preis für Anzeige
  static String formatPrice(double price) {
    return price.toStringAsFixed(2).replaceAll('.', ',');
  }

  /// Prüft ob String nur Ziffern, Komma und Punkt enthält
  static bool isValidPriceFormat(String value) {
    return RegExp(r'^[\d,\.]+$').hasMatch(value);
  }
}