import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'ingredients_screen.dart';
import 'add_edit_ingredient_screen.dart';

class IngredientDetailsScreen extends StatelessWidget {
  final Ingredient ingredient;
  final Function(Ingredient) onUpdate;
  final Function(String) onDelete;

  const IngredientDetailsScreen({
    super.key,
    required this.ingredient,
    required this.onUpdate,
    required this.onDelete,
  });

  void _showEditScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditIngredientScreen(
          initialCategory: ingredient.category,
          ingredient: ingredient,
          onSave: onUpdate,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF335B41),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ingredient.category.color, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              'Zutat löschen',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ],
        ),
        content: Text(
          'Möchten Sie "${ingredient.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Abbrechen',
              style: TextStyle(color: ingredient.category.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close details screen
              onDelete(ingredient.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFF335B41),
      body: Column(
        children: [
          // AppBar
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
                bottom: BorderSide(color: ingredient.category.color, width: 2),
              ),
            ),
            child: Row(
              children: [
                // Back Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ingredient.category.color, width: 2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: ingredient.category.color,
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
                    color: ingredient.category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ingredient.category.color, width: 1),
                  ),
                  child: Icon(
                    ingredient.category.icon,
                    size: 18,
                    color: ingredient.category.color,
                  ),
                ),
                const SizedBox(width: 12),

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
                      Text(
                        ingredient.category.displayName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showEditScreen(context),
                      child: const Icon(
                        Icons.edit,
                        color: Color(0xFFD4AF37),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Foto und Grundinfo Card
                  _buildMainInfoCard(),
                  const SizedBox(height: 16),

                  // Preisvergleich Card
                  _buildPriceComparisonCard(context),
                  const SizedBox(height: 16),

                  // Notizen Card (falls vorhanden)
                  if (ingredient.notes.isNotEmpty) ...[
                    _buildNotesCard(),
                    const SizedBox(height: 16),
                  ],

                  // Zusatzinfos Card
                  _buildAdditionalInfoCard(dateFormat),
                  const SizedBox(height: 16),

                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ingredient.category.color, width: 2),
        boxShadow: [
          BoxShadow(
            color: ingredient.category.color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ingredient.category.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ingredient.category.color, width: 2),
              ),
              child: ingredient.imagePath != null && File(ingredient.imagePath!).existsSync()
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.file(
                  File(ingredient.imagePath!),
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                ingredient.category.icon,
                size: 60,
                color: ingredient.category.color,
              ),
            ),

            const SizedBox(height: 20),

            // Name
            Text(
              ingredient.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ingredient.category.color,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Einheit
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: Text(
                'Einheit: ${ingredient.unit}',
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceComparisonCard(BuildContext context) {
    final allStores = <String, double>{...ingredient.prices};
    if (ingredient.otherStoreName != null && ingredient.otherStorePrice != null) {
      allStores[ingredient.otherStoreName!] = ingredient.otherStorePrice!;
    }

    if (allStores.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Color(0xFFD4AF37),
              size: 40,
            ),
            SizedBox(height: 12),
            Text(
              'Keine Preise erfasst',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Fügen Sie Preise hinzu, um einen Vergleich zu sehen',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Sort stores by price (cheapest first)
    final sortedStores = allStores.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.compare_arrows, color: Color(0xFFD4AF37)),
                SizedBox(width: 8),
                Text(
                  'Preisvergleich',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
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

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCheapest
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCheapest
                        ? const Color(0xFFD4AF37)
                        : Colors.grey.withValues(alpha: 0.3),
                    width: isCheapest ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (isCheapest) ...[
                      const Icon(
                        Icons.star,
                        color: Color(0xFFD4AF37),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],

                    Expanded(
                      child: Text(
                        storeEntry.key,
                        style: TextStyle(
                          color: isCheapest ? const Color(0xFFD4AF37) : Colors.white,
                          fontWeight: isCheapest ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),

                    Text(
                      '${storeEntry.value.toStringAsFixed(2)}€',
                      style: TextStyle(
                        color: isCheapest ? const Color(0xFFD4AF37) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: storeEntry.value.toStringAsFixed(2)));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Preis ${storeEntry.value.toStringAsFixed(2)}€ kopiert'),
                            backgroundColor: const Color(0xFFD4AF37),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.copy,
                        size: 16,
                        color: isCheapest ? const Color(0xFFD4AF37) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            if (sortedStores.length > 1) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      const Color(0xFFB8860B).withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD4AF37)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.savings,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ersparnis: ${(sortedStores.last.value - sortedStores.first.value).toStringAsFixed(2)}€',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.note, color: Color(0xFFD4AF37)),
                SizedBox(width: 8),
                Text(
                  'Notizen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
              ),
              child: Text(
                ingredient.notes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard(DateFormat dateFormat) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Color(0xFFD4AF37)),
                SizedBox(width: 8),
                Text(
                  'Zusatzinformationen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoRow('Kategorie', ingredient.category.displayName),
            _buildInfoRow('Einheit', ingredient.unit),
            _buildInfoRow('Letzte Aktualisierung', dateFormat.format(ingredient.lastUpdated)),
            if (ingredient.prices.isNotEmpty)
              _buildInfoRow('Anzahl Preise', '${ingredient.prices.length} ${ingredient.otherStorePrice != null ? '+ 1 sonstiger' : ''} Märkte'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showEditScreen(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Bearbeiten',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showDeleteDialog(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Löschen',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}