import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Zeigt Bottom Sheet zur Auswahl der Bildquelle
  static Future<String?> showImagePicker(
      BuildContext context, {
        Color accentColor = const Color(0xFFD4AF37),
        String? currentImagePath,
      }) async {
    return showModalBottomSheet<String?>(
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
            // Handle
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Foto auswählen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 24),

            // Optionen
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceButton(
                    context: context,
                    icon: Icons.camera_alt,
                    title: 'Kamera',
                    color: accentColor,
                    onTap: () async {
                      Navigator.pop(context);
                      final imagePath = await _takePhoto(ImageSource.camera);
                      Navigator.pop(context, imagePath);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceButton(
                    context: context,
                    icon: Icons.photo_library,
                    title: 'Galerie',
                    color: accentColor,
                    onTap: () async {
                      Navigator.pop(context);
                      final imagePath = await _takePhoto(ImageSource.gallery);
                      Navigator.pop(context, imagePath);
                    },
                  ),
                ),
              ],
            ),

            // Foto entfernen Option (nur wenn Foto vorhanden)
            if (currentImagePath != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _buildImageSourceButton(
                  context: context,
                  icon: Icons.delete,
                  title: 'Foto entfernen',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context, ''); // Leerer String = Foto entfernen
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

  /// Nimmt Foto auf oder wählt aus Galerie
  static Future<String?> _takePhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        return await saveImageToApp(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Fehler beim Aufnehmen des Fotos: $e');
      return null;
    }
  }

  /// Speichert Bild im App-Verzeichnis
  static Future<String> saveImageToApp(String originalPath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_image.jpg';
    final String newPath = path.join(appDir.path, 'images', fileName);

    // Verzeichnis erstellen falls nicht vorhanden
    await Directory(path.dirname(newPath)).create(recursive: true);

    // Datei kopieren
    await File(originalPath).copy(newPath);

    return newPath;
  }

  /// Löscht Bild aus App-Verzeichnis
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Fehler beim Löschen des Bildes: $e');
      return false;
    }
  }

  /// Prüft ob Bilddatei existiert
  static bool imageExists(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return File(imagePath).existsSync();
  }

  /// Erstellt Image Widget mit Fallback
  static Widget buildImageWidget({
    required String? imagePath,
    required double width,
    required double height,
    required Widget fallbackWidget,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imageExists(imagePath)) {
      Widget imageWidget = Image.file(
        File(imagePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallbackWidget,
      );

      if (borderRadius != null) {
        imageWidget = ClipRRect(
          borderRadius: borderRadius,
          child: imageWidget,
        );
      }

      return imageWidget;
    }

    return fallbackWidget;
  }

  /// Button für Bildquelle-Auswahl
  static Widget _buildImageSourceButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        color: color.withValues(alpha: 0.1),
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
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
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
}