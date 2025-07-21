import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../utils/constants.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;
  final Function(String name, String phoneNumber) onSave;

  const AddEditCustomerScreen({
    super.key,
    this.customer,
    required this.onSave,
  });

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _phoneController.text = widget.customer!.phoneNumber;
    }
  }

  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim(), _phoneController.text.trim());
      Navigator.pop(context);
      if (widget.customer != null) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return Scaffold(
      backgroundColor: AppConstants.primaryGreen,
      body: Column(
        children: [
          // Elegante AppBar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: const BoxDecoration(
              color: AppConstants.black,
              border: Border(
                bottom: BorderSide(
                  color: AppConstants.primaryGold,
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
                      color: AppConstants.primaryGold,
                      width: AppConstants.borderWidth,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppConstants.primaryGold,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  isEditing ? 'Kunde bearbeiten' : 'Neuer Kunde',
                  style: AppConstants.goldTitle,
                ),

                const Spacer(),
                const SizedBox(width: 40),
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
                    // Header Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: AppConstants.primaryGold,
                          width: AppConstants.borderWidth,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        size: 40,
                        color: AppConstants.primaryGold,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Name Feld
                    Container(
                      decoration: AppDecorations.goldBorder(),
                      child: TextFormField(
                        controller: _nameController,
                        style: AppConstants.whiteText,
                        decoration: const InputDecoration(
                          labelText: 'Name *',
                          labelStyle: TextStyle(color: AppConstants.primaryGold),
                          hintText: 'z.B. Familie Schmidt',
                          hintStyle: AppConstants.greyHint,
                          prefixIcon: Icon(Icons.person, color: AppConstants.primaryGold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Bitte geben Sie einen Namen ein';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Telefon Feld
                    Container(
                      decoration: AppDecorations.goldBorder(),
                      child: TextFormField(
                        controller: _phoneController,
                        style: AppConstants.whiteText,
                        decoration: const InputDecoration(
                          labelText: 'Telefonnummer *',
                          labelStyle: TextStyle(color: AppConstants.primaryGold),
                          hintText: 'z.B. +49 123 456789',
                          hintStyle: AppConstants.greyHint,
                          prefixIcon: Icon(Icons.phone, color: AppConstants.primaryGold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Bitte geben Sie eine Telefonnummer ein';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Speichern Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(
                          color: AppConstants.primaryGold,
                          width: AppConstants.borderWidth,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            AppConstants.primaryGold,
                            AppConstants.darkGold,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryGold.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          onTap: _saveCustomer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              isEditing ? 'Änderungen speichern' : 'Kunde hinzufügen',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}