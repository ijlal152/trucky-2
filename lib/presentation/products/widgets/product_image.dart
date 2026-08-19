import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/image_utils.dart';

/// In-memory cache of decoded product images keyed by their base64 string.
/// Bounded to avoid unbounded memory growth on large catalogs.
final Map<String, Uint8List> _base64ImageCache = <String, Uint8List>{};

/// Maximum number of decoded images kept in memory.
const int _maxCacheEntries = 64;

void _cacheImage(String key, Uint8List bytes) {
  if (_base64ImageCache.length >= _maxCacheEntries) {
    // Evict the oldest entry (insertion order) to keep the cache bounded.
    _base64ImageCache.remove(_base64ImageCache.keys.first);
  }
  _base64ImageCache[key] = bytes;
}

/// Decodes a base64 image on a background isolate (top-level so it works with
/// `compute`). Returns null when the payload is malformed.
Uint8List? _decodeBase64Image(String base64Image) {
  try {
    return ImageUtils.convertBase64ToImage(img: base64Image);
  } catch (_) {
    return null;
  }
}

Widget buildProductImage({
  required String? base64Image,
  double? imgHeight,
  double? imgWidth,
  bool isRoundImg = true,
}) {
  if (base64Image == null || base64Image.isEmpty) {
    return _productIcon(imgHeight, imgWidth);
  }
  return _AsyncDecodedImage(
    base64Image: base64Image,
    imgHeight: imgHeight,
    imgWidth: imgWidth,
    isRoundImg: isRoundImg,
  );
}

/// Decodes the base64 payload off the UI isolate, with the decoded bytes
/// cached in [_base64ImageCache] so repeated builds do not re-decode.
class _AsyncDecodedImage extends StatefulWidget {
  const _AsyncDecodedImage({
    required this.base64Image,
    this.imgHeight,
    this.imgWidth,
    this.isRoundImg = true,
  });

  final String base64Image;
  final double? imgHeight;
  final double? imgWidth;
  final bool isRoundImg;

  @override
  State<_AsyncDecodedImage> createState() => _AsyncDecodedImageState();
}

class _AsyncDecodedImageState extends State<_AsyncDecodedImage> {
  late final Future<Uint8List?> _decodeFuture = _decode();

  Future<Uint8List?> _decode() async {
    final cached = _base64ImageCache[widget.base64Image];
    if (cached != null) return cached;
    final bytes = await compute(_decodeBase64Image, widget.base64Image);
    if (bytes != null) _cacheImage(widget.base64Image, bytes);
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _decodeFuture,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return _productIcon(widget.imgHeight, widget.imgWidth);
        }
        return _buildImageWidget(
          bytes,
          widget.imgHeight,
          widget.imgWidth,
          widget.isRoundImg,
        );
      },
    );
  }
}

Widget _productIcon(double? height, double? width) {
  return Image.asset(
    AppAssets.images.productIcon,
    height: height ?? 48.h,
    width: width ?? 48.h,
  );
}

Widget _buildImageWidget(
  Uint8List data,
  double? height,
  double? width,
  bool isRound,
) {
  final image = Image.memory(
    data,
    height: height ?? 48.h,
    width: width ?? 48.h,
    fit: BoxFit.cover,
  );

  return isRound
      ? ClipOval(child: image)
      : ClipRRect(borderRadius: BorderRadius.circular(10.r), child: image);
}
