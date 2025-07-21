import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../utils/constants.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.goldBorder(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppConstants.primaryGold,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 28,
                    color: AppConstants.primaryGold,
                  ),
                ),

                const SizedBox(width: 16),

                // Kunde Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            customer.phoneNumber,
                            style: AppConstants.whiteText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Pfeil
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppConstants.primaryGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}