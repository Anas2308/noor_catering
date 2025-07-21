import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppConstants.primaryGold;

    return Container(
      decoration: AppDecorations.goldBorder(),
      child: TextFormField(
        controller: controller,
        style: AppConstants.whiteText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: effectiveBorderColor),
          hintText: hintText,
          hintStyle: AppConstants.greyHint,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: effectiveBorderColor)
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

class PriceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String storeName;
  final String? Function(String?)? validator;

  const PriceTextField({
    super.key,
    required this.controller,
    required this.storeName,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: '$storeName Preis (€)',
      hintText: '0,00',
      prefixIcon: Icons.store,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
      ],
      validator: validator ?? _defaultPriceValidator,
    );
  }

  String? _defaultPriceValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      final price = double.tryParse(value.replaceAll(',', '.'));
      if (price == null || price < 0) {
        return 'Ungültiger Preis';
      }
    }
    return null;
  }
}

class RequiredTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const RequiredTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.borderColor,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: '$labelText *',
      hintText: hintText,
      prefixIcon: prefixIcon,
      borderColor: borderColor,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bitte geben Sie $labelText ein';
        }
        return null;
      },
    );
  }
}