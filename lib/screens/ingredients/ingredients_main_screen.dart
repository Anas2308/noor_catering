import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../services/database_service.dart';  // DATABASE SERVICE!
import '../../widgets/ingredients/category_card.dart';
import '../../utils/constants.dart';
import 'category_ingredients_screen.dart';

class IngredientsMainScreen extends StatefulWidget {
  const IngredientsMainScreen({super.key});

  @override
  State<IngredientsMainScreen> createState() => _IngredientsMainScreenState();
}

class _IngredientsMainScreenState extends State<IngredientsMainScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final Map<IngredientCategory, List<Ingredient>> _ingredientsByCategory = {
    for (var category in IngredientCategory.values) category: <Ingredient>[]
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIngredientsFromDatabase();
  }

  // ===== DATABASE FUNKTIONEN =====

  /// Lade alle Zutaten aus der Datenbank
  Future<void> _loadIngredientsFromDatabase() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ingredientDBList = await _databaseService.getIngredients();

      // Konvertiere DB-Modelle zu App-Modellen und sortiere nach Kategorien
      setState(() {
        // Erst alle Listen leeren
        for (var category in IngredientCategory.values) {
          _ingredientsByCategory[category]!.clear();
        }

        // Dann Zutaten zu richtigen Kategorien hinzufügen
        for (final ingredientDB in ingredientDBList) {
          final ingredient = Ingredient(
            id: ingredientDB.id,
            name: ingredientDB.name,
            unit: ingredientDB.unit,
            prices: ingredientDB.prices,
            imagePath: ingredientDB.imagePath,
            category: IngredientCategory.values.firstWhere(
                  (c) => c.name == ingredientDB.category,
              orElse: () => IngredientCategory.others,
            ),
            notes: ingredientDB.notes,
            otherStoreName: ingredientDB.otherStoreName,
            otherStorePrice: ingredientDB.otherStorePrice,
            lastUpdated: DateTime.parse(ingredientDB.lastUpdated),
          );

          _ingredientsByCategory[ingredient.category]!.add(ingredient);
        }

        _isLoading = false;
      });

      debugPrint('✅ ${ingredientDBList.length} Zutaten aus Datenbank geladen');
    } catch (e) {
      debugPrint('❌ Fehler beim Laden der Zutaten: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Speichere Zutat in Datenbank
  Future<void> _saveIngredientToDatabase(Ingredient ingredient) async {
    try {
      final ingredientDB = IngredientDB(
        id: ingredient.id,
        name: ingredient.name,
        unit: ingredient.unit,
        prices: ingredient.prices,
        imagePath: ingredient.imagePath,
        category: ingredient.category.name,
        notes: ingredient.notes,
        otherStoreName: ingredient.otherStoreName,
        otherStorePrice: ingredient.otherStorePrice,
        lastUpdated: ingredient.lastUpdated.toIso8601String(),
      );

      await _databaseService.insertIngredient(ingredientDB);
      debugPrint('✅ Zutat "${ingredient.name}" in DB gespeichert');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zutat "${ingredient.name}" wurde hinzugefügt'),
            backgroundColor: AppConstants.primaryGold,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Speichern der Zutat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Speichern der Zutat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Aktualisiere Zutat in Datenbank
  Future<void> _updateIngredientInDatabase(Ingredient ingredient) async {
    try {
      final ingredientDB = IngredientDB(
        id: ingredient.id,
        name: ingredient.name,
        unit: ingredient.unit,
        prices: ingredient.prices,
        imagePath: ingredient.imagePath,
        category: ingredient.category.name,
        notes: ingredient.notes,
        otherStoreName: ingredient.otherStoreName,
        otherStorePrice: ingredient.otherStorePrice,
        lastUpdated: ingredient.lastUpdated.toIso8601String(),
      );

      await _databaseService.updateIngredient(ingredientDB);
      debugPrint('✅ Zutat "${ingredient.name}" in DB aktualisiert');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zutat "${ingredient.name}" wurde aktualisiert'),
            backgroundColor: AppConstants.primaryGold,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Aktualisieren der Zutat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Aktualisieren der Zutat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Lösche Zutat aus Datenbank
  Future<void> _deleteIngredientFromDatabase(String ingredientId) async {
    try {
      await _databaseService.deleteIngredient(ingredientId);
      debugPrint('✅ Zutat aus DB gelöscht');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Zutat wurde gelöscht'),
            backgroundColor: AppConstants.primaryGold,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Fehler beim Löschen der Zutat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Löschen der Zutat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCategoryIngredients(IngredientCategory category) async {
    // Navigation mit await - wartet auf Rückkehr
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryIngredientsScreen(
          category: category,
          ingredients: _ingredientsByCategory[category]!,
          onIngredientAdded: _saveIngredientToDatabase,    // DATABASE!
          onIngredientUpdated: _updateIngredientInDatabase, // DATABASE!
          onIngredientDeleted: _deleteIngredientFromDatabase, // DATABASE!
        ),
      ),
    );

    // Nach Rückkehr: Lade Daten neu aus Database
    await _loadIngredientsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryGreen,
      body: Column(
        children: [
          // Elegante AppBar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: const BoxDecoration(
              color: AppConstants.black,
              border: Border(
                bottom: BorderSide(
                  color: AppConstants.primaryGold,
                  width: AppConstants.borderWidth,
                ),
              ),
            ),
            child: Row(
              children: [
                // Zurück Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppConstants.primaryGold,
                      width: AppConstants.borderWidth,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppConstants.primaryGold,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                const Text(
                  'Zutaten',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                    letterSpacing: 1.5,
                  ),
                ),

                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Text mit Statistik
                  Row(
                    children: [
                      const Text(
                        'Kategorien',
                        style: AppConstants.goldTitle,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: AppDecorations.goldBorder(),
                        child: Text(
                          'Gesamt: ${_getTotalIngredientCount()}',
                          style: const TextStyle(
                            color: AppConstants.primaryGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Wählen Sie eine Kategorie aus',
                    style: AppConstants.whiteText,
                  ),

                  const SizedBox(height: 24),

                  // Kategorien Grid - 2 Spalten
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: IngredientCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = IngredientCategory.values[index];
                      final ingredientCount = _ingredientsByCategory[category]!.length;

                      return CategoryCard(
                        category: category,
                        ingredientCount: ingredientCount,
                        onTap: () => _showCategoryIngredients(category),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppConstants.primaryGold,
          ),
          SizedBox(height: 16),
          Text(
            'Lade Zutaten...',
            style: TextStyle(
              color: AppConstants.primaryGold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalIngredientCount() {
    return _ingredientsByCategory.values
        .fold(0, (sum, ingredients) => sum + ingredients.length);
  }
}