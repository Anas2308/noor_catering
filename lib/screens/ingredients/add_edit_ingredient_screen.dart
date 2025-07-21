import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'ingredients_screen.dart';

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
  final ImagePicker _picker = ImagePicker();

  final List<String> _units = [
    'kg', 'g', 'Liter', 'ml', 'Stück', 'Bund', 'Packung', 'Dose', 'Flasche'
  ];

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

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF335B41),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: Color(0xFFD4AF37), width: 2),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Foto auswählen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    title: 'Kamera',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.photo_library,
                    title: 'Galerie',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            if (_imagePath != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _buildImageSourceButton(
                  icon: Icons.delete,
                  title: 'Foto entfernen',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _imagePath = null;
                    });
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? _selectedCategory.color;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: buttonColor, width: 2),
        color: buttonColor.withValues(alpha: 0.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: buttonColor, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: buttonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_ingredient.jpg';
        final String newPath = path.join(appDir.path, 'ingredients', fileName);

        await Directory(path.dirname(newPath)).create(recursive: true);
        await File(image.path).copy(newPath);

        setState(() {
          _imagePath = newPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden des Fotos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveIngredient() {
    if (_formKey.currentState!.validate()) {
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

      widget.onSave(ingredient);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ingredient != null;

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
                bottom: BorderSide(color: _selectedCategory.color, width: 2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _selectedCategory.color, width: 2),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
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
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Foto Bereich
                    _buildPhotoSection(),
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

  Widget _buildPhotoSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedCategory.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt, color: _selectedCategory.color),
                const SizedBox(width: 8),
                Text(
                  'Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedCategory.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _selectedCategory.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedCategory.color, width: 2),
                ),
                child: _imagePath != null && File(_imagePath!).existsSync()
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: _selectedCategory.color,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Foto hinzufügen',
                      style: TextStyle(
                        color: _selectedCategory.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedCategory.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name der Zutat *',
                labelStyle: TextStyle(color: _selectedCategory.color),
                hintText: 'z.B. Basmati Reis',
                hintStyle: const TextStyle(color: Colors.grey),
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
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF335B41),
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
              items: _units.map((unit) => DropdownMenuItem(
                value: unit,
                child: Text(unit, style: const TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: (value) {
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
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedCategory.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF335B41),
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
                    Text(category.displayName, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              )).toList(),
              onChanged: (value) {
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
                Icon(Icons.euro, color: Color(0xFFD4AF37)),
                SizedBox(width: 8),
                Text(
                  'Preise pro Einheit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
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
                color: Color(0xFFD4AF37),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Marktname',
                      labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
                      hintText: 'z.B. Kaufland',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _otherStorePriceController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Preis €',
                      labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
                      hintText: '0,00',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
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
      style: const TextStyle(color: Colors.white),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      ],
      decoration: InputDecoration(
        labelText: '$storeName Preis (€)',
        labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
        hintText: '0,00',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
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
                  'Notizen (optional)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'z.B. Bio-Qualität, besondere Marke, Allergiehinweise...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _selectedCategory.color, width: 2),
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
          borderRadius: BorderRadius.circular(12),
          onTap: _saveIngredient,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              isEditing ? 'Änderungen speichern' : 'Zutat hinzufügen',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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