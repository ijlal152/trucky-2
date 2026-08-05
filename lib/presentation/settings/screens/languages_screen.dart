import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class LanguagesScreen extends StatelessWidget {
  static const String id = '/settings/languages';

  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CustomScaffold(
          appBar: CustomAppBar(
            title: 'Language',
            actionWidgets: [
              Image.asset(
                AppAssets.images.searchIcon,
                height: 24.h,
              ).paddingSymmetric(horizontal: 15.w),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => context
                      .read<SettingsBloc>()
                      .add(SelectLanguageEvent(index: index)),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: _LanguageRow(
                        language: state.languagesList[index],
                        isSelected: state.selectedLanguageIndex == index,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => dividerWidget(),
              itemCount: state.languagesList.length,
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
          ),
        );
      },
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String language;
  final bool isSelected;

  const _LanguageRow({required this.language, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LabelWidget(
          text: language,
          textSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
        if (isSelected)
          Image.asset(AppAssets.images.checkIconGreen, height: 12.h),
      ],
    );
  }
}