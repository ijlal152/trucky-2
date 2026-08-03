import 'package:flutter/material.dart';
import 'package:trucky/presentation/widgets/custom_floating_btn.dart';

/// FAB that scales based on a scroll-driven animation.
class ScrollAwareFAB extends StatelessWidget {
  final VoidCallback onTap;
  final String? imgPath;
  final IconData icon;
  final Animation<double> scale;

  const ScrollAwareFAB({
    super.key,
    required this.onTap,
    required this.scale,
    this.imgPath,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: CustomFloatingBtn(imgPath: imgPath, icon: icon, onTap: onTap),
    );
  }
}
