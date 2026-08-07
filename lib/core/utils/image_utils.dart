import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Helpers to convert images to/from base64.
abstract final class ImageUtils {
  static String convertImageToBase64({required File img}) {
    final List<int> imageBytes = img.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  /// Base64-encodes raw image bytes. Top-level so it can run on a background
  /// isolate via `compute` (avoids blocking the UI thread).
  static String encodeImageBytes(Uint8List bytes) => base64Encode(bytes);

  static Uint8List convertBase64ToImage({required String img}) {
    return base64Decode(img);
  }
}
