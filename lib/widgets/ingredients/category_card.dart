import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../utils/constants.dart';

class CategoryCard extends StatelessWidget {
  final IngredientCategory category;
  final int ingredientCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.ingredientCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppConstants.primaryGold,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGold.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                    color: AppConstants.primaryGold,
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
                    color: AppConstants.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppConstants.primaryGold,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '$ingredientCount',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppConstants.primaryGold,
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