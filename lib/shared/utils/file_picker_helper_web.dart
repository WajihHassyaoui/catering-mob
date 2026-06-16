// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';

class FilePickerHelper {
  static Future<Map<String, dynamic>?> pickImage() async {
    final completer = Completer<Map<String, dynamic>?>();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((e) {
          completer.complete({
            'name': file.name,
            'bytes': reader.result as Uint8List,
          });
        });
        
        reader.onError.listen((e) {
          completer.completeError(e);
        });
        
        reader.readAsArrayBuffer(file);
      } else {
        completer.complete(null);
      }
    });
    
    return completer.future;
  }
}
