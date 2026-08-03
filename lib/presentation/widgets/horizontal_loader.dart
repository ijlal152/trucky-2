import 'package:flutter/material.dart';
import 'package:trucky/core/theme/app_colors.dart';

class HorizontalLoader extends StatefulWidget {
  const HorizontalLoader({
    super.key,
    this.color = AppColors.buttonBgColor,
    this.trackColor = const Color(0x1A000000),
    this.height = 3,
    this.duration = const Duration(milliseconds: 1200),
  });

  final Color color;
  final Color trackColor;
  final double height;
  final Duration duration;

  @override
  State<HorizontalLoader> createState() => _HorizontalLoaderState();
}

class _HorizontalLoaderState extends State<HorizontalLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.height / 2),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: ColoredBox(
          color: widget.trackColor,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FractionallySizedBox(
                widthFactor: 0.35,
                alignment: Alignment(-1.0 + 2.0 * _controller.value, 0.0),
                child: ColoredBox(color: widget.color),
              );
            },
          ),
        ),
      ),
    );
  }
}
