import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../utils/constants.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.categoryBorder(ingredient.category.color),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Row(
              children: [
                // Icon oder Bild
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: ingredient.category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: ingredient.category.color,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    ingredient.category.icon,
                    size: 28,
                    color: ingredient.category.color,
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
                          color: ingredient.category.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Einheit: ${ingredient.unit}',
                        style: AppConstants.whiteText.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      if (ingredient.prices.isNotEmpty)
                        Text(
                          '${ingredient.cheapestPrice.toStringAsFixed(2)}€ bei ${ingredient.cheapestStore}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppConstants.primaryGold,
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
                  color: ingredient.category.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}