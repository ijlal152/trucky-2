import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback settingOnTap;
  const HomeHeaderWidget({super.key, required this.settingOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      AppAssets.images.person,
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
                  ),
                ),
                15.horizontalSpace,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Hello, User",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        "Demo Version",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
              ],
            ),
          ),
          GestureDetector(
            onTap: settingOnTap,
            child: Image.asset(
              AppAssets.images.settingsIcon,
              height: 30.h,
              width: 30.h,
            ),
          ),
        ],
      ),
    );
  }
}
