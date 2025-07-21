import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../widgets/ingredients/category_card.dart';
import '../../utils/constants.dart';
import 'category_ingredients_screen.dart';

class IngredientsMainScreen extends StatefulWidget {
  const IngredientsMainScreen({super.key});

  @override
  State<IngredientsMainScreen> createState() => _IngredientsMainScreenState();
}

class _IngredientsMainScreenState extends State<IngredientsMainScreen> {
  final Map<IngredientCategory, List<Ingredient>> _ingredientsByCategory = {
    for (var category in IngredientCategory.values) category: <Ingredient>[]
  };

  @override
  void initState() {
    super.initState();
    // Keine Beispieldaten - startet leer
  }

  void _showCategoryIngredients(IngredientCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryIngredientsScreen(
          category: category,
          ingredients: _ingredientsByCategory[category]!,
          onIngredientAdded: (ingredient) {
            setState(() {
              _ingredientsByCategory[category]!.add(ingredient);
            });
          },
          onIngredientUpdated: (ingredient) {
            setState(() {
              final index = _ingredientsByCategory[category]!
                  .indexWhere((i) => i.id == ingredient.id);
              if (index != -1) {
                _ingredientsByCategory[category]![index] = ingredient;
              }
            });
          },
          onIngredientDeleted: (ingredientId) {
            setState(() {
              _ingredientsByCategory[category]!
                  .removeWhere((i) => i.id == ingredientId);
            });
          },
        ),
      ),
    );
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Text
                  const Text(
                    'Kategorien',
                    style: AppConstants.goldTitle,
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
}