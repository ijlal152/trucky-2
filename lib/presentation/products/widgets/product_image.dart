import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/image_utils.dart';

/// In-memory cache of decoded product images keyed by their base64 string.
final Map<String, Uint8List> _base64ImageCache = {};

Widget buildProductImage({
  required String? base64Image,
  double? imgHeight,
  double? imgWidth,
  bool isRoundImg = true,
}) {
  if (base64Image == null || base64Image.isEmpty) {
    return _productIcon(imgHeight, imgWidth);
  }

  Uint8List? bytes = _base64ImageCache[base64Image];
  if (bytes == null) {
    try {
      bytes = ImageUtils.convertBase64ToImage(img: base64Image);
    } catch (_) {
      // Malformed base64; fall through to the broken-image icon.
    }
    if (bytes == null) {
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }
    _base64ImageCache[base64Image] = bytes;
  }

  return _buildImageWidget(bytes, imgHeight, imgWidth, isRoundImg);
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
