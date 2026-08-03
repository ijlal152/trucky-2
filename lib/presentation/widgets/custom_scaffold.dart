import 'package:flutter/material.dart';
import 'package:trucky/core/theme/app_colors.dart';

/// Wraps a [Scaffold] with a soft gradient background.
class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Gradient? gradientBackground;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor = Colors.transparent,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset,
    this.gradientBackground = AppColors.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradientBackground),
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: appBar,
          backgroundColor: backgroundColor,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
