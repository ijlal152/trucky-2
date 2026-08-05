import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Select client screen used to pick the client for a treasury payment.
class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  int _selectedIndex = 0;

  static const List<String> _clients = [
    'Younes BECHEKH',
    'Client 2',
    'Client 3',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Select client',
        actionWidgets: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                AppAssets.images.searchIcon,
                height: 24.h,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _clients.length; i++) ...[
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 20.w,
                      ),
                      child: switchUserWidget(
                        title: _clients[i],
                        isSelected: _selectedIndex == i,
                      ),
                    ),
                  ),
                ),
                if (i < _clients.length - 1) dividerWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget switchUserWidget({
    required String title,
    required bool isSelected,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LabelWidget(
          text: title,
          textSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
        isSelected
            ? Image.asset(
                AppAssets.images.checkIconGreen,
                height: 12.h,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}