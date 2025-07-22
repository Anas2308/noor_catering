import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../widgets/ingredients/ingredient_card.dart';
import '../../utils/constants.dart';
import '../ingredients/add_edit_ingredient_screen.dart';
import '../ingredients/ingredient_details_screen.dart';

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
  late List<Ingredient> _localIngredients;

  @override
  void initState() {
    super.initState();
    // Kopiere die übergebenen Zutaten in lokale Liste
    _localIngredients = List.from(widget.ingredients);
  }

  void _showAddIngredientDialog() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditIngredientScreen(
          initialCategory: widget.category,
          onSave: (ingredient) async {
            // Speichere in Database
            await widget.onIngredientAdded(ingredient);

            // Aktualisiere lokale Liste sofort
            setState(() {
              _localIngredients.add(ingredient);
            });
          },
        ),
      ),
    );
  }

  void _showIngredientDetails(Ingredient ingredient) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientDetailsScreen(
          ingredient: ingredient,
          onUpdate: (updatedIngredient) async {
            // Speichere Update in Database
            await widget.onIngredientUpdated(updatedIngredient);

            // Aktualisiere lokale Liste sofort
            setState(() {
              final index = _localIngredients.indexWhere((i) => i.id == updatedIngredient.id);
              if (index != -1) {
                _localIngredients[index] = updatedIngredient;
              }
            });
          },
          onDelete: (ingredientId) async {
            // Lösche aus Database
            await widget.onIngredientDeleted(ingredientId);

            // Entferne aus lokaler Liste sofort
            setState(() {
              _localIngredients.removeWhere((i) => i.id == ingredientId);
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
          // AppBar with category color accent
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: AppConstants.black,
              border: Border(
                bottom: BorderSide(
                  color: widget.category.color,
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
                      color: widget.category.color,
                      width: AppConstants.borderWidth,
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
            child: _localIngredients.isEmpty
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
                width: AppConstants.borderWidth,
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
            style: AppConstants.whiteText,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: widget.category.color,
                width: AppConstants.borderWidth,
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
          padding: const EdgeInsets.all(AppConstants.padding),
          margin: const EdgeInsets.all(AppConstants.padding),
          decoration: AppDecorations.categoryBorder(widget.category.color),
          child: Row(
            children: [
              Icon(
                widget.category.icon,
                color: widget.category.color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${_localIngredients.length} ${_localIngredients.length == 1 ? 'Zutat' : 'Zutaten'}',
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
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
            itemCount: _localIngredients.length,
            itemBuilder: (context, index) {
              final ingredient = _localIngredients[index];
              return IngredientCard(
                ingredient: ingredient,
                onTap: () => _showIngredientDetails(ingredient),
              );
            },
          ),
        ),
      ],
    );
  }
}