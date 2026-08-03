import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Manages a scroll-aware FAB animation and its scroll controller.
///
/// GetX-free replacement for the old `CustomFabController`.
class CustomFabController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  bool isFabVisible = false;

  CustomFabController(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      animationController,
    );

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    final direction = scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && !isFabVisible) {
      isFabVisible = true;
      animationController.forward();
    } else if (direction == ScrollDirection.forward && isFabVisible) {
      isFabVisible = false;
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }
}
