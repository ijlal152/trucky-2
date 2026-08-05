import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/theme/app_colors.dart';
import 'package:trucky/core/utils/image_utils.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_models.dart';
import 'package:trucky/presentation/settings/widgets/select_country_code_bottom_sheet.dart';
import 'package:trucky/presentation/widgets/bottom_sheet_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_image_picker.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';
import 'package:trucky/presentation/widgets/textfield_validation_error.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  static const String id = '/settings/edit-personal-info';

  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneNoController;
  late final TextEditingController _businessNameController;
  late final TextEditingController _addressController;

  String? _countryCode;
  File? _profileImage;
  bool _isNameRequired = false;
  bool _isPhoneRequired = false;
  bool _isBusinessRequired = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsBloc>().state.user;
    _fullNameController = TextEditingController(text: user.fullName);
    _phoneNoController = TextEditingController(text: user.phoneNumber);
    _businessNameController = TextEditingController(text: user.businessName);
    _addressController = TextEditingController(text: user.address);
    _countryCode = user.countryCode;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNoController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _selectCountryCode() async {
    final selected = await showModalBottomSheet<CountryCodeAndCurrencyModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SelectCountryCodeBottomSheet(),
    );
    if (selected != null && selected.dialCode != null) {
      setState(() => _countryCode = selected.dialCode);
    }
  }

  void _updateUser() {
    setState(() {
      _isNameRequired = _fullNameController.text.trim().isEmpty;
      _isPhoneRequired = _phoneNoController.text.trim().isEmpty;
      _isBusinessRequired = _businessNameController.text.trim().isEmpty;
    });
    if (_isNameRequired || _isPhoneRequired || _isBusinessRequired) {
      return;
    }

    context.read<SettingsBloc>().add(
          UpdateUserEvent(
            fullName: _fullNameController.text.trim(),
            businessName: _businessNameController.text.trim(),
            phoneNumber: _phoneNoController.text.trim(),
            countryCode: _countryCode,
            address: _addressController.text.trim(),
            profilePicture: _profileImage != null
                ? ImageUtils.convertImageToBase64(img: _profileImage!)
                : null,
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<SettingsBloc>().state.user;
    final hasPicture = user.profilePicture != null;

    return CustomScaffold(
          appBar: const CustomAppBar(title: 'Edit Personal Information'),
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      bottomSheetWidget(
                        bottomSheetWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const DividerWidget(color: Color(0xFFBDC3DD)),
                            20.verticalSpace,
                            imagePickerOption(
                              img: AppAssets.images.gallery,
                              option: 'Pick image from gallery',
                              onTap: () {
                                context.pop();
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                            15.verticalSpace,
                            imagePickerOption(
                              img: AppAssets.images.camera,
                              option: 'Pick image from camera',
                              onTap: () {
                                context.pop();
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            30.verticalSpace,
                          ],
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 100.h,
                          width: 100.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : hasPicture
                                    ? DecorationImage(
                                        image: MemoryImage(
                                          ImageUtils.convertBase64ToImage(
                                            img: user.profilePicture!,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: AssetImage(
                                          AppAssets.images.person,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              if (hasPicture)
                                FutureBuilder<Uint8List>(
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
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 27.h,
                                  width: 27.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      size: 15.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                  CustomTextFormField(
                    hintText: 'Full Name',
                    labelText: 'Full Name',
                    controller: _fullNameController,
                    errorBorderColor:
                        _isNameRequired ? Colors.red : Colors.white,
                  ),
                  textFieldValidationError(
                    requiredParameter: 'Full name is required',
                    isValid: !_isNameRequired,
                  ),
                  20.verticalSpace,
                  Card(
                    elevation: 0,
                    child: Container(
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _selectCountryCode,
                            child: Container(
                              width: 90.w,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LabelWidget(
                                    text: _countryCode ?? '',
                                    textSize: 17.sp,
                                    fontWeight: FontWeight.normal,
                                    textColor: Colors.black,
                                  ),
                                  4.horizontalSpace,
                                  Image.asset(
                                    AppAssets.images.arrowDown,
                                    width: 12.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const VerticalDivider()
                              .paddingSymmetric(vertical: 15.h),
                          Flexible(
                            child: CustomTextFormField(
                              hintText: 'Phone Number',
                              controller: _phoneNoController,
                              textInputType: TextInputType.number,
                              errorBorderColor: _isPhoneRequired
                                  ? Colors.red
                                  : Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[1-9]\d*'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  textFieldValidationError(
                    requiredParameter: 'Phone number is required',
                    isValid: !_isPhoneRequired,
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    controller: _businessNameController,
                    hintText: 'Business Name',
                    labelText: 'Business Name',
                    errorBorderColor:
                        _isBusinessRequired ? Colors.red : Colors.white,
                  ),
                  textFieldValidationError(
                    requiredParameter: 'Business is required',
                    isValid: !_isBusinessRequired,
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    hintText: 'Address',
                    labelText: 'Address',
                    controller: _addressController,
                  ),
                  20.verticalSpace,
                ],
              ).paddingSymmetric(horizontal: 20.w),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBarWidget(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomElevatedButton(
                  onTap: _updateUser,
                  btnTitle: 'Update',
                ),
              ],
            ),
          ),
        );
  }
}