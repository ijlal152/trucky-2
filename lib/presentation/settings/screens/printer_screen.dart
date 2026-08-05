import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/theme/app_colors.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Bluetooth printer device picker.
///
/// UI-only port: real BLE scanning (`flutter_blue_plus`) is not wired up yet,
/// so this screen renders the interface and manages the toggle locally.
class BlueToothDevicesScreen extends StatefulWidget {
  static const String id = '/settings/printer';

  const BlueToothDevicesScreen({super.key});

  @override
  State<BlueToothDevicesScreen> createState() => _BlueToothDevicesScreenState();
}

class _BlueToothDevicesScreenState extends State<BlueToothDevicesScreen> {
  bool _isBluetoothOn = false;
  bool _isScanning = false;

  void _toggleBluetooth(bool value) {
    setState(() => _isBluetoothOn = value);
  }

  Future<void> _startScan() async {
    setState(() => _isScanning = true);
    await Future<void>.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Bluetooth Devices'),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SwitchListTile(
              title: LabelWidget(
                text: 'Bluetooth',
                textSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              subtitle: LabelWidget(
                text: _isBluetoothOn ? 'On' : 'Off',
                textSize: 14.sp,
                textColor: _isBluetoothOn ? Colors.green : Colors.grey,
              ),
              value: _isBluetoothOn,
              onChanged: _toggleBluetooth,
            ),
          ),
          if (_isBluetoothOn)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _startScan,
                icon: Icon(
                  _isScanning ? Icons.refresh : Icons.bluetooth_searching,
                  size: 20.sp,
                  color: Colors.white,
                ),
                label: LabelWidget(
                  text: _isScanning ? 'Scanning...' : 'Scan for Devices',
                  textSize: 14.sp,
                  textColor: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBgColor,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          16.verticalSpace,
          if (_isBluetoothOn)
            Expanded(
              child: _isScanning
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bluetooth_disabled,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          16.verticalSpace,
                          LabelWidget(
                            text: 'No devices found',
                            textSize: 16.sp,
                            textColor: Colors.grey,
                          ),
                          8.verticalSpace,
                          LabelWidget(
                            text: 'Make sure your device is discoverable',
                            textSize: 14.sp,
                            textColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bluetooth_disabled,
                      size: 64.sp,
                      color: Colors.grey,
                    ),
                    16.verticalSpace,
                    LabelWidget(
                      text: 'Bluetooth is turned off',
                      textSize: 16.sp,
                      textColor: Colors.grey,
                    ),
                    8.verticalSpace,
                    LabelWidget(
                      text: 'Turn on Bluetooth to scan for devices',
                      textSize: 14.sp,
                      textColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}