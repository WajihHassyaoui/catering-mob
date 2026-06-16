import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  static Future<Map<String, dynamic>?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      return {
        'name': image.name,
        'bytes': bytes,
      };
    }
    return null;
  }
}
