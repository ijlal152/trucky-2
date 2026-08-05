import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/widgets/custom_alert_dialog.dart';
import 'package:trucky/presentation/settings/widgets/navigatable_row_with_image.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';

class PersonalInformationSection extends StatelessWidget {
  const PersonalInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(RoutePaths.personalInformation),
            child: Container(
              color: Colors.white,
              child: NavigatableRowWithImage(
                title: 'Personal information',
                img: AppAssets.images.personalInfo,
              ).paddingOnly(top: 15.h, bottom: 5.h),
            ),
          ),
          dividerWidget(),
          GestureDetector(
            onTap: () => context.push(RoutePaths.security),
            child: Container(
              color: Colors.white,
              child: NavigatableRowWithImage(
                title: 'Security',
                img: AppAssets.images.lock,
              ).paddingOnly(top: 5.h, bottom: 15.h),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}

class UtilitiesSection extends StatelessWidget {
  const UtilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(RoutePaths.languages),
            child: Container(
              color: Colors.white,
              child: NavigatableRowWithImage(
                title: 'Language',
                img: AppAssets.images.language,
              ).paddingOnly(top: 15.h, bottom: 5.h),
            ),
          ),
          dividerWidget(),
          GestureDetector(
            onTap: () => context.push(RoutePaths.currency),
            child: Container(
              color: Colors.white,
              child: NavigatableRowWithImage(
                title: 'Currency',
                img: AppAssets.images.currency,
              ).paddingOnly(top: 5.h, bottom: 5.h),
            ),
          ),
          dividerWidget(),
          GestureDetector(
            onTap: () => context.push(RoutePaths.printer),
            child: Container(
              color: Colors.transparent,
              child: NavigatableRowWithImage(
                title: 'Printing',
                img: AppAssets.images.share,
              ).paddingOnly(top: 5.h, bottom: 5.h),
            ),
          ),
          dividerWidget(),
          GestureDetector(
            onTap: () => context.push(RoutePaths.subscription),
            child: Container(
              color: Colors.transparent,
              child: NavigatableRowWithImage(
                title: 'Subscription',
                img: AppAssets.images.subscription,
              ).paddingOnly(top: 5.h, bottom: 5.h),
            ),
          ),
          dividerWidget(),
          GestureDetector(
            onTap: () => context.push(RoutePaths.backup),
            child: Container(
              color: Colors.transparent,
              child: NavigatableRowWithImage(
                title: 'Backup status',
                img: AppAssets.images.backup,
              ).paddingOnly(top: 5.h, bottom: 15.h),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}

class TermsAndHelpSection extends StatelessWidget {
  const TermsAndHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          NavigatableRowWithImage(
            title: 'Terms & conditions',
            img: AppAssets.images.terms,
          ).paddingOnly(top: 15.h, bottom: 5.h),
          dividerWidget(),
          NavigatableRowWithImage(
            title: 'Privacy policy',
            img: AppAssets.images.privacy,
          ).paddingOnly(top: 5.h, bottom: 5.h),
          dividerWidget(),
          NavigatableRowWithImage(
            title: 'Help',
            img: AppAssets.images.help,
          ).paddingOnly(top: 5.h, bottom: 15.h),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomAlertDialog(
          context: context,
          title: 'Warning!',
          message: 'Do you really want to logout ?',
          yesOnTap: () {
            context.pop();
            context.go(RoutePaths.home);
          },
          cancelOnTap: () {
            context.pop();
          },
        );
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            NavigatableRowWithImage(
              title: 'Logout',
              img: AppAssets.images.logout,
            ).paddingOnly(top: 15.h, bottom: 15.h),
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }
}