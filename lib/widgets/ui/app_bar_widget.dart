import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Color? accentColor;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.accentColor,
    this.onBackPressed,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? AppConstants.primaryGold;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          bottom: BorderSide(
            color: effectiveAccentColor,
            width: AppConstants.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Leading Widget oder Back Button
          leading ?? _buildBackButton(context, effectiveAccentColor),

          const Spacer(),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: effectiveAccentColor,
              letterSpacing: 1.2,
            ),
          ),

          const Spacer(),

          // Actions oder Platzhalter
          if (actions != null)
            Row(children: actions!)
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: AppConstants.borderWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onBackPressed ?? () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class CategoryAppBar extends StatelessWidget {
  final String title;
  final Color categoryColor;
  final IconData categoryIcon;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CategoryAppBar({
    super.key,
    required this.title,
    required this.categoryColor,
    required this.categoryIcon,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          bottom: BorderSide(
            color: categoryColor,
            width: AppConstants.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: categoryColor,
                width: AppConstants.borderWidth,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onBackPressed ?? () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: categoryColor,
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
              color: categoryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: categoryColor,
                width: 1,
              ),
            ),
            child: Icon(
              categoryIcon,
              size: 18,
              color: categoryColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: categoryColor,
                letterSpacing: 1.0,
              ),
            ),
          ),

          // Actions
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}