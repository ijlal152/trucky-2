import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Floating action button used across the app.
class CustomFloatingBtn extends StatelessWidget {
  final String? imgPath;
  final IconData icon;
  final VoidCallback onTap;

  const CustomFloatingBtn({
    super.key,
    this.imgPath,
    required this.onTap,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: 56.h,
      child: FloatingActionButton(
        onPressed: onTap,
        heroTag: null,
        backgroundColor: const Color.fromRGBO(43, 136, 216, 1),
        child: imgPath != null
            ? SvgPicture.asset(imgPath!)
            : Icon(icon, size: 22.h, color: Colors.white),
      ),
    );
  }
}
