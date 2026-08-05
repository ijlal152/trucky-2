import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class SubscriptionStatusScreen extends StatelessWidget {
  static const String id = '/settings/subscription';

  const SubscriptionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Subscription Status'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildFeaturesList(),
            SizedBox(height: 16.h),
            _buildActionButtons(),
            SizedBox(height: 20.h),
          ],
        ).paddingSymmetric(horizontal: 16.w),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: LabelWidget(
              text: 'Plan Features',
              textSize: 16.sp,
              fontWeight: FontWeight.bold,
              textColor: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: LabelWidget(
                  text: 'Renew Subscription',
                  textSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: LabelWidget(
                  text: 'View All Plans',
                  textSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: LabelWidget(
                  text: 'Cancel Subscription',
                  textSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}