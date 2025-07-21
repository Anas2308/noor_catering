import 'package:flutter/material.dart';
import '../../models/ingredient.dart';  // Nutze zentrale Models
import 'add_edit_ingredient_screen.dart';
import 'ingredient_details_screen.dart';

// ALTE SCREEN VERSION - sollte durch ingredients_main_screen.dart ersetzt werden
// Nur als Backup falls die neue Struktur noch nicht funktioniert

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
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
      backgroundColor: const Color(0xFF335B41),
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
              color: Color(0xFF000000),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFD4AF37),
                  width: 2,
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
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFD4AF37),
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
                    color: Color(0xFFD4AF37),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Text
                  const Text(
                    'Kategorien',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Wählen Sie eine Kategorie aus',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Kategorien Grid - 2 Spalten aber kleinere Boxen
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Zurück zu 2 Spalten
                      childAspectRatio: 1.3, // Flacher als vorher
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: IngredientCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = IngredientCategory.values[index];
                      final ingredientCount = _ingredientsByCategory[category]!.length;

                      return _buildCategoryCard(category, ingredientCount);
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

  Widget _buildCategoryCard(IngredientCategory category, int ingredientCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCategoryIngredients(category),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon mit Kategorie-Farbe
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: category.color,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    category.icon,
                    size: 24,
                    color: category.color,
                  ),
                ),

                const SizedBox(height: 8),

                // Kategorie Name
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Anzahl der Zutaten
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '$ingredientCount',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Category Ingredients Screen
class CategoryIngredientsScreen extends StatefulWidget {
  final IngredientCategory category;
  final List<Ingredient> ingredients;
  final Function(Ingredient) onIngredientAdded;
  final Function(Ingredient) onIngredientUpdated;
  final Function(String) onIngredientDeleted;

  const CategoryIngredientsScreen({
    super.key,
    required this.category,
    required this.ingredients,
    required this.onIngredientAdded,
    required this.onIngredientUpdated,
    required this.onIngredientDeleted,
  });

  @override
  State<CategoryIngredientsScreen> createState() => _CategoryIngredientsScreenState();
}

class _CategoryIngredientsScreenState extends State<CategoryIngredientsScreen> {
  void _showAddIngredientDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditIngredientScreen(
          initialCategory: widget.category,
          onSave: widget.onIngredientAdded,
        ),
      ),
    );
  }

  void _showIngredientDetails(Ingredient ingredient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientDetailsScreen(
          ingredient: ingredient,
          onUpdate: widget.onIngredientUpdated,
          onDelete: widget.onIngredientDeleted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF335B41),
      body: Column(
        children: [
          // AppBar with category color accent
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              border: Border(
                bottom: BorderSide(
                  color: widget.category.color,
                  width: 2,
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
                      color: widget.category.color,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: widget.category.color,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Category Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.category.color,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.category.icon,
                    size: 18,
                    color: widget.category.color,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    widget.category.displayName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.category.color,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: widget.ingredients.isEmpty
                ? _buildEmptyState()
                : _buildIngredientsList(),
          ),
        ],
      ),

      // FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              widget.category.color,
              widget.category.color.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.category.color.withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _showAddIngredientDialog,
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: widget.category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: widget.category.color,
                width: 2,
              ),
            ),
            child: Icon(
              widget.category.icon,
              size: 60,
              color: widget.category.color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Keine ${widget.category.displayName}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.category.color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fügen Sie Ihre erste Zutat hinzu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: widget.category.color,
                width: 2,
              ),
              gradient: LinearGradient(
                colors: [
                  widget.category.color,
                  widget.category.color.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: _showAddIngredientDialog,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Erste Zutat hinzufügen',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      children: [
        // Header mit Anzahl
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.category.color,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.category.icon,
                color: widget.category.color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${widget.ingredients.length} ${widget.ingredients.length == 1 ? 'Zutat' : 'Zutaten'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.category.color,
                ),
              ),
            ],
          ),
        ),

        // Ingredients List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredients[index];
              return _buildIngredientCard(ingredient);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(Ingredient ingredient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.category.color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.category.color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showIngredientDetails(ingredient),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon oder Bild
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: widget.category.color,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.category.icon,
                    size: 28,
                    color: widget.category.color,
                  ),
                ),

                const SizedBox(width: 16),

                // Ingredient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.category.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Einheit: ${ingredient.unit}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (ingredient.prices.isNotEmpty)
                        Text(
                          '${ingredient.cheapestPrice.toStringAsFixed(2)}€ bei ${ingredient.cheapestStore}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),

                // Pfeil
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: widget.category.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}