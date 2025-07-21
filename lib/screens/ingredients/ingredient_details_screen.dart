import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../models/ingredient.dart';  // KORRIGIERT: Nutze zentrale Models
import '../../utils/constants.dart';
import '../../widgets/ingredients/price_comparison_widget.dart';
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
        backgroundColor: AppConstants.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: BorderSide(color: ingredient.category.color, width: AppConstants.borderWidth),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              'Zutat löschen',
              style: TextStyle(color: AppConstants.primaryGold),
            ),
          ],
        ),
        content: Text(
          'Möchten Sie "${ingredient.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
          style: AppConstants.whiteText,
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
      backgroundColor: AppConstants.primaryGreen,
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
              color: AppConstants.black,
              border: Border(
                bottom: BorderSide(color: ingredient.category.color, width: AppConstants.borderWidth),
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
                    border: Border.all(color: ingredient.category.color, width: AppConstants.borderWidth),
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
                        style: AppConstants.whiteText.copyWith(fontSize: 12),
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
                    border: Border.all(color: AppConstants.primaryGold, width: AppConstants.borderWidth),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showEditScreen(context),
                      child: const Icon(
                        Icons.edit,
                        color: AppConstants.primaryGold,
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
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                children: [
                  // Foto und Grundinfo Card
                  _buildMainInfoCard(),
                  const SizedBox(height: 16),

                  // Preisvergleich Card
                  PriceComparisonWidget(ingredient: ingredient),
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
        border: Border.all(color: ingredient.category.color, width: AppConstants.borderWidth),
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
                border: Border.all(color: ingredient.category.color, width: AppConstants.borderWidth),
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
                color: AppConstants.primaryGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: AppConstants.primaryGold),
              ),
              child: Text(
                'Einheit: ${ingredient.unit}',
                style: const TextStyle(
                  color: AppConstants.primaryGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
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
                Icon(Icons.note, color: AppConstants.primaryGold),
                SizedBox(width: 8),
                Text(
                  'Notizen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
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
                border: Border.all(color: AppConstants.primaryGold.withValues(alpha: 0.3)),
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
      decoration: AppDecorations.goldBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: AppConstants.primaryGold),
                SizedBox(width: 8),
                Text(
                  'Zusatzinformationen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
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
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppConstants.primaryGold, width: AppConstants.borderWidth),
              gradient: const LinearGradient(
                colors: [AppConstants.primaryGold, AppConstants.darkGold],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: Colors.red, width: AppConstants.borderWidth),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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