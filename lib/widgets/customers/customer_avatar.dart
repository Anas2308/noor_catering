import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CustomerAvatar extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderWidth;

  const CustomerAvatar({
    super.key,
    this.size = 56,
    this.backgroundColor,
    this.iconColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = size / 2;
    final double iconSize = size * 0.5;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppConstants.primaryGold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: iconColor ?? AppConstants.primaryGold,
          width: borderWidth ?? 1,
        ),
      ),
      child: Icon(
        Icons.person,
        size: iconSize,
        color: iconColor ?? AppConstants.primaryGold,
      ),
    );
  }
}

class LargeCustomerAvatar extends StatelessWidget {
  final String? imagePath;
  final Color borderColor;

  const LargeCustomerAvatar({
    super.key,
    this.imagePath,
    this.borderColor = AppConstants.primaryGold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: borderColor,
          width: 3,
        ),
      ),
      child: imagePath != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(47),
        child: Image.network(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person,
            size: 50,
            color: borderColor,
          ),
        ),
      )
          : Icon(
        Icons.person,
        size: 50,
        color: borderColor,
      ),
    );
  }
}