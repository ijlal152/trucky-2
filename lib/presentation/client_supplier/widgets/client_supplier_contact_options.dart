import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/presentation/widgets/custom_snackbar.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// Call / SMS / GPS action buttons for a client or supplier.
class ContactOptionsWidget extends StatelessWidget {
  final String? phoneNumber;
  final String? gpsLocation;
  final void Function(double, double)? onLocationPressed;
  final String callButtonTitle;
  final String smsButtonTitle;
  final String gpsButtonTitle;
  final String noPhoneError;
  final String noGpsError;

  const ContactOptionsWidget({
    super.key,
    required this.phoneNumber,
    required this.gpsLocation,
    required this.onLocationPressed,
    this.callButtonTitle = 'Call',
    this.smsButtonTitle = 'SMS',
    this.gpsButtonTitle = 'GPS',
    this.noPhoneError = 'No phone number available!',
    this.noGpsError = 'No GPS location available!',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.15),
              offset: const Offset(0, 15),
              blurRadius: 48.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildActionButton(
              title: callButtonTitle,
              img: AppAssets.images.callPng,
              onTap: _handleCallPressed,
            ),
            _buildVerticalDivider(),
            _buildActionButton(
              title: smsButtonTitle,
              img: AppAssets.images.smsPng,
              onTap: _handleSmsPressed,
            ),
            _buildVerticalDivider(),
            _buildActionButton(
              title: gpsButtonTitle,
              img: AppAssets.images.gpgPng,
              onTap: _handleGpsPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15.h),
          width: 1.w,
          height: 50.h,
          decoration: BoxDecoration(color: Colors.grey[200]),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String img,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(img, height: 55.h),
          6.verticalSpace,
          LabelWidget(
            text: title,
            textSize: 13.sp,
            fontFamily: FontConstants.interBold,
            fontWeight: FontWeight.w600,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Future<void> _handleCallPressed() async {
    if (_isPhoneNumberInvalid) {
      MySnackbarMessage.showErrorMessage(
        title: 'Error!',
        message: noPhoneError,
      );
      return;
    }
    await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
  }

  Future<void> _handleSmsPressed() async {
    if (_isPhoneNumberInvalid) {
      MySnackbarMessage.showErrorMessage(
        title: 'Error!',
        message: noPhoneError,
      );
      return;
    }
    await launchUrl(Uri(scheme: 'sms', path: phoneNumber));
  }

  Future<void> _handleGpsPressed() async {
    if (_isGpsInvalid) {
      MySnackbarMessage.showErrorMessage(title: 'Error!', message: noGpsError);
      return;
    }
    final coords = gpsLocation!.split(',');
    onLocationPressed?.call(double.parse(coords[0]), double.parse(coords[1]));
  }

  bool get _isPhoneNumberInvalid => phoneNumber == null || phoneNumber!.isEmpty;

  bool get _isGpsInvalid => gpsLocation == null || gpsLocation!.isEmpty;
}
