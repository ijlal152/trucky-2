import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/theme/app_colors.dart';
import 'package:trucky/core/utils/image_utils.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';
import 'package:trucky/presentation/settings/widgets/personal_info_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class PersonalInformationScreen extends StatelessWidget {
  static const String id = '/settings/personal-information';

  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final user = state.user;
        final hasPicture = user.profilePicture != null;

        return CustomScaffold(
          appBar: const CustomAppBar(title: 'Personal information'),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 100.h,
                    width: 100.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: hasPicture
                          ? DecorationImage(
                              image: MemoryImage(
                                ImageUtils.convertBase64ToImage(
                                  img: user.profilePicture!,
                                ),
                              ),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage(AppAssets.images.person),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: hasPicture
                        ? FutureBuilder<Uint8List>(
                            future: Future.delayed(
                              const Duration(milliseconds: 300),
                              () => ImageUtils.convertBase64ToImage(
                                img: user.profilePicture!,
                              ),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.buttonBgColor,
                                  ),
                                );
                              }
                              return Container();
                            },
                          )
                        : Container(),
                  ),
                ),
                20.verticalSpace,
                LabelWidget(
                  text: user.businessName,
                  textSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                ).paddingSymmetric(horizontal: 20.w),
                5.verticalSpace,
                LabelWidget(
                  text: user.fullName,
                  textSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(0, 0, 0, 0.72),
                ),
                40.verticalSpace,
                PersonalInfoWidget(
                  headingText: 'Full Name',
                  personalInfoData: user.fullName,
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: dividerWidget(),
                ),
                PersonalInfoWidget(
                  headingText: 'Phone Number',
                  personalInfoData:
                      '${user.countryCode}${user.phoneNumber}',
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: dividerWidget(),
                ),
                PersonalInfoWidget(
                  headingText: 'Business Name',
                  personalInfoData: user.businessName,
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: dividerWidget(),
                ),
                PersonalInfoWidget(
                  headingText: 'Address',
                  personalInfoData: user.address,
                  onTap: () {},
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBarWidget(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomElevatedButton(
                  btnTitle: 'Edit',
                  onTap: () => context.push(RoutePaths.editPersonalInfo),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}