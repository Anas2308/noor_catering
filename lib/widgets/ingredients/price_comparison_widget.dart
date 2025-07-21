import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/ingredient.dart';
import '../../utils/constants.dart';

class PriceComparisonWidget extends StatelessWidget {
  final Ingredient ingredient;

  const PriceComparisonWidget({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final allStores = <String, double>{...ingredient.prices};
    if (ingredient.otherStoreName != null && ingredient.otherStorePrice != null) {
      allStores[ingredient.otherStoreName!] = ingredient.otherStorePrice!;
    }

    if (allStores.isEmpty) {
      return _buildEmptyState();
    }

    // Sort stores by price (cheapest first)
    final sortedStores = allStores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Container(
      width: double.infinity,
      decoration: AppDecorations.goldBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.compare_arrows, color: AppConstants.primaryGold),
                SizedBox(width: 8),
                Text(
                  'Preisvergleich',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price list
            ...sortedStores.asMap().entries.map((entry) {
              final index = entry.key;
              final storeEntry = entry.value;
              final isCheapest = index == 0;

              return _buildPriceRow(
                context,
                storeEntry.key,
                storeEntry.value,
                isCheapest,
              );
            }).toList(),

            // Savings indicator
            if (sortedStores.length > 1) ...[
              const SizedBox(height: 12),
              _buildSavingsIndicator(sortedStores),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.goldBorder(),
      child: const Column(
        children: [
          Icon(
            Icons.info_outline,
            color: AppConstants.primaryGold,
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'Keine Preise erfasst',
            style: TextStyle(
              color: AppConstants.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Fügen Sie Preise hinzu, um einen Vergleich zu sehen',
            style: AppConstants.whiteText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      BuildContext context,
      String storeName,
      double price,
      bool isCheapest,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCheapest
            ? AppConstants.primaryGold.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCheapest
              ? AppConstants.primaryGold
              : Colors.grey.withValues(alpha: 0.3),
          width: isCheapest ? AppConstants.borderWidth : 1,
        ),
      ),
      child: Row(
        children: [
          if (isCheapest) ...[
            const Icon(
              Icons.star,
              color: AppConstants.primaryGold,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],

          Expanded(
            child: Text(
              storeName,
              style: TextStyle(
                color: isCheapest ? AppConstants.primaryGold : Colors.white,
                fontWeight: isCheapest ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          Text(
            '${price.toStringAsFixed(2)}€',
            style: TextStyle(
              color: isCheapest ? AppConstants.primaryGold : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: price.toStringAsFixed(2)));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Preis ${price.toStringAsFixed(2)}€ kopiert'),
                  backgroundColor: AppConstants.primaryGold,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(
              Icons.copy,
              size: 16,
              color: isCheapest ? AppConstants.primaryGold : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsIndicator(List<MapEntry<String, double>> sortedStores) {
    final savings = sortedStores.last.value - sortedStores.first.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryGold.withValues(alpha: 0.3),
            AppConstants.darkGold.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.primaryGold),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.savings,
            color: AppConstants.primaryGold,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ersparnis: ${savings.toStringAsFixed(2)}€',
              style: const TextStyle(
                color: AppConstants.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}