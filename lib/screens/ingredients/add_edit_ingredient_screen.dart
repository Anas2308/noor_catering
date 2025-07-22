import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/ingredient.dart';
import '../../widgets/ingredients/photo_picker_widget.dart';
import '../../utils/constants.dart';

class AddEditIngredientScreen extends StatefulWidget {
  final IngredientCategory initialCategory;
  final Ingredient? ingredient;
  final Function(Ingredient) onSave;

  const AddEditIngredientScreen({
    super.key,
    required this.initialCategory,
    this.ingredient,
    required this.onSave,
  });

  @override
  State<AddEditIngredientScreen> createState() => _AddEditIngredientScreenState();
}

class _AddEditIngredientScreenState extends State<AddEditIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _reweController = TextEditingController();
  final _edekaController = TextEditingController();
  final _lidlController = TextEditingController();
  final _otherStoreNameController = TextEditingController();
  final _otherStorePriceController = TextEditingController();

  String _selectedUnit = 'kg';
  IngredientCategory _selectedCategory = IngredientCategory.vegetables;
  String? _imagePath;
  bool _isSaving = false; // Für Loading State

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;

    if (widget.ingredient != null) {
      final ingredient = widget.ingredient!;
      _nameController.text = ingredient.name;
      _selectedUnit = ingredient.unit;
      _selectedCategory = ingredient.category;
      _notesController.text = ingredient.notes;
      _imagePath = ingredient.imagePath;

      _reweController.text = ingredient.prices['REWE']?.toString() ?? '';
      _edekaController.text = ingredient.prices['Edeka']?.toString() ?? '';
      _lidlController.text = ingredient.prices['Lidl']?.toString() ?? '';
      _otherStoreNameController.text = ingredient.otherStoreName ?? '';
      _otherStorePriceController.text = ingredient.otherStorePrice?.toString() ?? '';
    }
  }

  // ← HIER IST DER FIX!
  Future<void> _saveIngredient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true; // Zeige Loading
      });

      try {
        final prices = <String, double>{};

        if (_reweController.text.isNotEmpty) {
          prices['REWE'] = double.parse(_reweController.text.replaceAll(',', '.'));
        }
        if (_edekaController.text.isNotEmpty) {
          prices['Edeka'] = double.parse(_edekaController.text.replaceAll(',', '.'));
        }
        if (_lidlController.text.isNotEmpty) {
          prices['Lidl'] = double.parse(_lidlController.text.replaceAll(',', '.'));
        }

        String? otherStoreName;
        double? otherStorePrice;
        if (_otherStoreNameController.text.isNotEmpty && _otherStorePriceController.text.isNotEmpty) {
          otherStoreName = _otherStoreNameController.text.trim();
          otherStorePrice = double.parse(_otherStorePriceController.text.replaceAll(',', '.'));
        }

        final ingredient = Ingredient(
          id: widget.ingredient?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          unit: _selectedUnit,
          prices: prices,
          imagePath: _imagePath,
          category: _selectedCategory,
          notes: _notesController.text.trim(),
          otherStoreName: otherStoreName,
          otherStorePrice: otherStorePrice,
          lastUpdated: DateTime.now(),
        );

        // WARTE auf die Database-Operation!
        await widget.onSave(ingredient);

        // Erst DANN navigiere zurück
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('❌ Fehler beim Speichern: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fehler beim Speichern der Zutat'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false; // Verstecke Loading
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ingredient != null;

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
                bottom: BorderSide(color: _selectedCategory.color, width: AppConstants.borderWidth),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _selectedCategory.color, width: AppConstants.borderWidth),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _isSaving ? null : () => Navigator.pop(context), // Disable während Speichern
                      child: Icon(
                        Icons.arrow_back,
                        color: _selectedCategory.color,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _selectedCategory.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _selectedCategory.color),
                  ),
                  child: Icon(
                    _selectedCategory.icon,
                    size: 18,
                    color: _selectedCategory.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEditing ? 'Zutat bearbeiten' : 'Neue Zutat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _selectedCategory.color,
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Foto Bereich
                    PhotoPickerWidget(
                      imagePath: _imagePath,
                      category: _selectedCategory,
                      onImageChanged: (newImagePath) {
                        setState(() {
                          _imagePath = newImagePath;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Name & Einheit
                    _buildBasicInfoSection(),
                    const SizedBox(height: 20),

                    // Kategorie
                    _buildCategorySection(),
                    const SizedBox(height: 20),

                    // Preise
                    _buildPricesSection(),
                    const SizedBox(height: 20),

                    // Notizen
                    _buildNotesSection(),
                    const SizedBox(height: 32),

                    // Speichern Button
                    _buildSaveButton(isEditing),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      decoration: AppDecorations.categoryBorder(_selectedCategory.color),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: _selectedCategory.color),
                const SizedBox(width: 8),
                Text(
                  'Grundinformationen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedCategory.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _nameController,
              style: AppConstants.whiteText,
              enabled: !_isSaving, // Disable während Speichern
              decoration: InputDecoration(
                labelText: 'Name der Zutat *',
                labelStyle: TextStyle(color: _selectedCategory.color),
                hintText: 'z.B. Basmati Reis',
                hintStyle: AppConstants.greyHint,
                prefixIcon: Icon(Icons.label, color: _selectedCategory.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bitte geben Sie einen Namen ein';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            // Einheit Dropdown
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              style: AppConstants.whiteText,
              dropdownColor: AppConstants.primaryGreen,
              decoration: InputDecoration(
                labelText: 'Einheit *',
                labelStyle: TextStyle(color: _selectedCategory.color),
                prefixIcon: Icon(Icons.straighten, color: _selectedCategory.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color, width: 2),
                ),
              ),
              items: AppConstants.units.map((unit) => DropdownMenuItem(
                value: unit,
                child: Text(unit, style: AppConstants.whiteText),
              )).toList(),
              onChanged: _isSaving ? null : (value) { // Disable während Speichern
                setState(() {
                  _selectedUnit = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      decoration: AppDecorations.categoryBorder(_selectedCategory.color),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: _selectedCategory.color),
                const SizedBox(width: 8),
                Text(
                  'Kategorie',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedCategory.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IngredientCategory>(
              value: _selectedCategory,
              style: AppConstants.whiteText,
              dropdownColor: AppConstants.primaryGreen,
              decoration: InputDecoration(
                labelText: 'Kategorie auswählen',
                labelStyle: TextStyle(color: _selectedCategory.color),
                prefixIcon: Icon(_selectedCategory.icon, color: _selectedCategory.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: _selectedCategory.color, width: 2),
                ),
              ),
              items: IngredientCategory.values.map((category) => DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color, size: 20),
                    const SizedBox(width: 8),
                    Text(category.displayName, style: AppConstants.whiteText),
                  ],
                ),
              )).toList(),
              onChanged: _isSaving ? null : (value) { // Disable während Speichern
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricesSection() {
    return Container(
      decoration: AppDecorations.goldBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.euro, color: AppConstants.primaryGold),
                SizedBox(width: 8),
                Text(
                  'Preise pro Einheit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // REWE Preis
            _buildPriceField('REWE', _reweController, Icons.store),
            const SizedBox(height: 12),

            // Edeka Preis
            _buildPriceField('Edeka', _edekaController, Icons.store),
            const SizedBox(height: 12),

            // Lidl Preis
            _buildPriceField('Lidl', _lidlController, Icons.store),
            const SizedBox(height: 16),

            // Sonstiger Markt
            const Text(
              'Sonstiger Markt:',
              style: TextStyle(
                color: AppConstants.primaryGold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _otherStoreNameController,
                    style: AppConstants.whiteText,
                    enabled: !_isSaving, // Disable während Speichern
                    decoration: InputDecoration(
                      labelText: 'Marktname',
                      labelStyle: const TextStyle(color: AppConstants.primaryGold),
                      hintText: 'z.B. Kaufland',
                      hintStyle: AppConstants.greyHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold, width: 2),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _otherStorePriceController,
                    style: AppConstants.whiteText,
                    enabled: !_isSaving, // Disable während Speichern
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Preis €',
                      labelStyle: const TextStyle(color: AppConstants.primaryGold),
                      hintText: '0,00',
                      hintStyle: AppConstants.greyHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppConstants.primaryGold, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (_otherStoreNameController.text.isNotEmpty && (value == null || value.isEmpty)) {
                        return 'Preis fehlt';
                      }
                      if (value != null && value.isNotEmpty) {
                        final price = double.tryParse(value.replaceAll(',', '.'));
                        if (price == null || price < 0) {
                          return 'Ungültiger Preis';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceField(String storeName, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      style: AppConstants.whiteText,
      enabled: !_isSaving, // Disable während Speichern
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      ],
      decoration: InputDecoration(
        labelText: '$storeName Preis (€)',
        labelStyle: const TextStyle(color: AppConstants.primaryGold),
        hintText: '0,00',
        hintStyle: AppConstants.greyHint,
        prefixIcon: Icon(icon, color: AppConstants.primaryGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.primaryGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.primaryGold, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.primaryGold, width: 2),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final price = double.tryParse(value.replaceAll(',', '.'));
          if (price == null || price < 0) {
            return 'Ungültiger Preis';
          }
        }
        return null;
      },
    );
  }

  Widget _buildNotesSection() {
    return Container(
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
                  'Notizen (optional)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              style: AppConstants.whiteText,
              enabled: !_isSaving, // Disable während Speichern
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'z.B. Bio-Qualität, besondere Marke, Allergiehinweise...',
                hintStyle: AppConstants.greyHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppConstants.primaryGold),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppConstants.primaryGold, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppConstants.primaryGold, width: 2),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: _selectedCategory.color, width: AppConstants.borderWidth),
        gradient: LinearGradient(
          colors: [
            _selectedCategory.color,
            _selectedCategory.color.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _selectedCategory.color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          onTap: _isSaving ? null : _saveIngredient, // Disable während Speichern
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSaving) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  _isSaving
                      ? 'Speichere...'
                      : (isEditing ? 'Änderungen speichern' : 'Zutat hinzufügen'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _reweController.dispose();
    _edekaController.dispose();
    _lidlController.dispose();
    _otherStoreNameController.dispose();
    _otherStorePriceController.dispose();
    super.dispose();
  }
}