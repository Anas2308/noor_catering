import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'ingredients_screen.dart'; // Import für Models

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

      // Load prices
      _reweController.text = ingredient.prices['REWE']?.toString() ?? '';
      _edekaController.text = ingredient.prices['Edeka']?.toString() ?? '';
      _lidlController.text = ingredient.prices['Lidl']?.toString() ?? '';
      _otherStoreNameController.text = ingredient.otherStoreName ?? '';
      _otherStorePriceController.text = ingredient.otherStorePrice?.toString() ?? '';
    }
  }