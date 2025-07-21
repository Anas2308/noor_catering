import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import '../../services/image_service.dart';
import '../../utils/constants.dart';

class PhotoPickerWidget extends StatelessWidget {
  final String? imagePath;
  final IngredientCategory category;
  final Function(String?) onImageChanged;

  const PhotoPickerWidget({
    super.key,
    required this.imagePath,
    required this.category,
    required this.onImageChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    final newImagePath = await ImageService.showImagePicker(
      context,
      accentColor: category.color,
      currentImagePath: imagePath,
    );

    if (newImagePath != null) {
      // Leerer String bedeutet Foto entfernen
      if (newImagePath.isEmpty) {
        onImageChanged(null);
      } else {
        onImageChanged(newImagePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: category.color, width: AppConstants.borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt, color: category.color),
                const SizedBox(width: 8),
                Text(
                  'Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: category.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  border: Border.all(color: category.color, width: AppConstants.borderWidth),
                ),
                child: ImageService.buildImageWidget(
                  imagePath: imagePath,
                  width: 120,
                  height: 120,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius - 2),
                  fallbackWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: category.color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Foto hinzufügen',
                        style: TextStyle(
                          color: category.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}