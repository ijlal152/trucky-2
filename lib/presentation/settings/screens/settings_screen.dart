import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/presentation/settings/widgets/settings_screen_widgets.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PersonalInformationSection(),
              5.verticalSpace,
              const UtilitiesSection(),
              5.verticalSpace,
              const TermsAndHelpSection(),
              5.verticalSpace,
              const LogoutSection(),
            ],
          ),
        ),
      ),
    );
  }
}