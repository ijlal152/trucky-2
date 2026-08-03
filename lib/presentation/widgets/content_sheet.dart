import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Rounded white sheet with optional search/sort header used as list content.
class ContentSheet extends StatelessWidget {
  final VoidCallback filterIconOnTap;
  final VoidCallback searchIconOnTap;
  final bool isSortFeatureEnabled;
  final bool showSearchField;
  final bool isBarCodeEnabled;
  final Widget? contentWidget;
  final Function(String)? onChanged;
  final String sortType;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const ContentSheet({
    super.key,
    required this.filterIconOnTap,
    required this.searchIconOnTap,
    this.isSortFeatureEnabled = true,
    this.showSearchField = false,
    this.isBarCodeEnabled = false,
    this.onChanged,
    this.sortType = '',
    this.focusNode,
    this.controller,
    this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          if (isSortFeatureEnabled)
            searchAndSortWidget(
              filterIconOnTap: filterIconOnTap,
              searchIconOnTap: searchIconOnTap,
              showSearchField: showSearchField,
              onChanged: onChanged,
              sortType: sortType,
              focusNode: focusNode,
              controller: controller,
              enableQr: isBarCodeEnabled,
            ),
          Expanded(child: contentWidget ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}

Widget searchAndSortWidget({
  required VoidCallback filterIconOnTap,
  required VoidCallback searchIconOnTap,
  Function(String)? onChanged,
  String sortType = '',
  bool showSearchField = false,
  FocusNode? focusNode,
  TextEditingController? controller,
  bool enableQr = false,
}) {
  return Container(
    height: 60.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(246, 247, 248, 1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.r),
        topRight: Radius.circular(30.r),
      ),
      border: Border(
        bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
      ),
    ),
    child: showSearchField == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: filterIconOnTap,
                child: Image.asset(AppAssets.images.filterIcon, height: 24.h),
              ),
              LabelWidget(
                text: 'Sort By : $sortType',
                textSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (enableQr)
                    Image.asset(
                      AppAssets.images.barCodeScanner,
                      height: 24.h,
                    ),
                  if (enableQr) 15.horizontalSpace,
                  GestureDetector(
                    onTap: searchIconOnTap,
                    child: Image.asset(
                      AppAssets.images.searchIcon,
                      height: 24.h,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ContentSheetTextField(
                  hintText: 'Search by client name',
                  fillColor: Colors.transparent,
                  controller: controller,
                  onChanged: onChanged,
                  focusNode: focusNode,
                ).paddingSymmetric(horizontal: 15.w),
              ),
              GestureDetector(
                onTap: searchIconOnTap,
                child: Icon(Icons.cancel_outlined, size: 24.sp),
              ),
            ],
          ),
  );
}
