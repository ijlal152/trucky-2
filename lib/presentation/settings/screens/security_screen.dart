import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';
import 'package:trucky/presentation/settings/widgets/personal_info_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

class SecurityScreen extends StatelessWidget {
  static const String id = '/settings/security';

  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CustomScaffold(
          appBar: const CustomAppBar(title: 'Security'),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PersonalInfoWidget(
                  headingText: 'Email',
                  personalInfoData: state.user.email,
                  isEditEnabled: true,
                  onTap: () {},
                ),
                dividerWidget(),
                PersonalInfoWidget(
                  headingText: 'Password',
                  personalInfoData: '*********',
                  isEditEnabled: true,
                  onTap: () => context.push(RoutePaths.editPassword),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}