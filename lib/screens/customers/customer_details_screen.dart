import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/customer.dart';
import '../../widgets/customers/customer_avatar.dart';
import '../../utils/constants.dart';
import 'add_edit_customer_screen.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;
  final Function(String id, String name, String phoneNumber) onUpdate;
  final Function(String id) onDelete;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
    required this.onUpdate,
    required this.onDelete,
  });

  void _showEditDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCustomerScreen(
          customer: customer,
          onSave: (name, phoneNumber) {
            onUpdate(customer.id, name, phoneNumber);
          },
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
          side: const BorderSide(color: AppConstants.primaryGold, width: AppConstants.borderWidth),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Kunde löschen',
              style: TextStyle(color: AppConstants.primaryGold),
            ),
          ],
        ),
        content: Text(
          'Möchten Sie "${customer.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
          style: AppConstants.whiteText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Abbrechen',
              style: TextStyle(color: AppConstants.primaryGold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onDelete(customer.id);
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

                const Text(
                  'Kunde Details',
                  style: AppConstants.goldTitle,
                ),

                const Spacer(),

                // Edit Button
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
                      onTap: () => _showEditDialog(context),
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
                  // Hauptkarte mit goldenem Rahmen
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppConstants.primaryGold,
                        width: AppConstants.borderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryGold.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Avatar
                          const LargeCustomerAvatar(),

                          const SizedBox(height: 20),

                          // Name
                          Text(
                            customer.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryGold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          // Telefonnummer Karte
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppConstants.padding),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              border: Border.all(
                                color: AppConstants.primaryGold,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: AppConstants.primaryGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    customer.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: customer.phoneNumber));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Telefonnummer kopiert'),
                                        backgroundColor: AppConstants.primaryGold,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: AppConstants.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Aktionen
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                              onTap: () => _showEditDialog(context),
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
                            border: Border.all(
                              color: Colors.red,
                              width: AppConstants.borderWidth,
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}