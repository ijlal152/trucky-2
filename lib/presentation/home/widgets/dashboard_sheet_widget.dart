// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashBoardSheetWidget extends StatelessWidget {
  const DashBoardSheetWidget({
    super.key,
    required this.onProductsTap,
    required this.onSuppliersTap,
    required this.onClientsTap,
    required this.onSalesTap,
    required this.onPurchasesTap,
    required this.onTreasuryTap,
    required this.onAnalysisTap,
    this.productCount = 0,
  });

  final VoidCallback onProductsTap;
  final VoidCallback onSuppliersTap;
  final VoidCallback onClientsTap;
  final VoidCallback onSalesTap;
  final VoidCallback onPurchasesTap;
  final VoidCallback onTreasuryTap;
  final VoidCallback onAnalysisTap;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 35.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dashBoardFeatureItem(
                total: "0",
                title: "Sales",
                onTap: onSalesTap,
              ),
              dashBoardFeatureItem(
                total: "0",
                title: "Purchases",
                onTap: onPurchasesTap,
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dashBoardFeatureItem(
                title: "Suppliers",
                total: "0",
                onTap: onSuppliersTap,
              ),

              dashBoardFeatureItem(
                title: "Clients",
                total: "0",
                onTap: onClientsTap,
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dashBoardFeatureItem(
                title: "Products",
                total: productCount.toString(),
                onTap: onProductsTap,
              ),
              dashBoardFeatureItem(
                title: "Treasury",
                total: "0",
                onTap: onTreasuryTap,
              ),
            ],
          ),
          20.verticalSpace,
          analysisWidget(onAnalysisTap),
        ],
      ),
    );
  }
}

Widget analysisWidget(VoidCallback onAnalysisTap) {
  return InkWell(
    onTap: onAnalysisTap,
    child: Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          "Analysis",
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
      ),
    ),
  );
}

Widget dashBoardFeatureItem({
  String total = "0",
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SizedBox(
        width: 180.w,
        height: 130.h,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                total,
                style: TextStyle(fontSize: 22.sp, color: Colors.black),
              ),
              7.verticalSpace,
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
