import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../widgets/customers/customer_card.dart';
import '../../utils/constants.dart';
import 'customer_details_screen.dart';
import 'add_edit_customer_screen.dart';

class CustomersMainScreen extends StatefulWidget {
  const CustomersMainScreen({super.key});

  @override
  State<CustomersMainScreen> createState() => _CustomersMainScreenState();
}

class _CustomersMainScreenState extends State<CustomersMainScreen> {
  final List<Customer> _customers = [];

  void _addCustomer(String name, String phoneNumber) {
    setState(() {
      _customers.add(Customer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phoneNumber: phoneNumber,
      ));
    });
  }

  void _updateCustomer(String id, String name, String phoneNumber) {
    setState(() {
      final customerIndex = _customers.indexWhere((c) => c.id == id);
      if (customerIndex != -1) {
        _customers[customerIndex].name = name;
        _customers[customerIndex].phoneNumber = phoneNumber;
      }
    });
  }

  void _deleteCustomer(String id) {
    setState(() {
      _customers.removeWhere((c) => c.id == id);
    });
  }

  void _showCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(
          customer: customer,
          onUpdate: _updateCustomer,
          onDelete: _deleteCustomer,
        ),
      ),
    );
  }

  void _showAddCustomerDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCustomerScreen(
          onSave: _addCustomer,
        ),
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
                  'Kunden',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGold,
                    letterSpacing: 1.5,
                  ),
                ),

                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Content Bereich
          Expanded(
            child: _customers.isEmpty ? _buildEmptyState() : _buildCustomersList(),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _showAddCustomerDialog,
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: AppConstants.primaryGold,
                width: AppConstants.borderWidth,
              ),
            ),
            child: const Icon(
              Icons.people_outline,
              size: 60,
              color: AppConstants.primaryGold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Noch keine Kunden',
            style: AppConstants.goldTitle,
          ),
          const SizedBox(height: 8),
          const Text(
            'Fügen Sie Ihren ersten Kunden hinzu',
            style: AppConstants.whiteText,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
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
                borderRadius: BorderRadius.circular(25),
                onTap: _showAddCustomerDialog,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Ersten Kunden hinzufügen',
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
        ],
      ),
    );
  }

  Widget _buildCustomersList() {
    return Column(
      children: [
        // Header mit Anzahl
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.padding),
          margin: const EdgeInsets.all(AppConstants.padding),
          decoration: AppDecorations.goldBorder(),
          child: Row(
            children: [
              const Icon(
                Icons.people,
                color: AppConstants.primaryGold,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${_customers.length} ${_customers.length == 1 ? 'Kunde' : 'Kunden'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryGold,
                ),
              ),
            ],
          ),
        ),

        // Kunden Liste
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
            itemCount: _customers.length,
            itemBuilder: (context, index) {
              final customer = _customers[index];
              return CustomerCard(
                customer: customer,
                onTap: () => _showCustomerDetails(customer),
              );
            },
          ),
        ),
      ],
    );
  }
}