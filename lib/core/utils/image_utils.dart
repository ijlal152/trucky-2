import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Helpers to convert images to/from base64.
abstract final class ImageUtils {
  static String convertImageToBase64({required File img}) {
    final List<int> imageBytes = img.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  static Uint8List convertBase64ToImage({required String img}) {
    return base64Decode(img);
  }
}
