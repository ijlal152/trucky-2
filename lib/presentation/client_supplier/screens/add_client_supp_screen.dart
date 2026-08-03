import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';
import 'package:trucky/presentation/widgets/textfield_validation_error.dart';

/// Add Client / Supplier screen.
class AddClientSuppScreen extends StatefulWidget {
  const AddClientSuppScreen({super.key});

  @override
  State<AddClientSuppScreen> createState() => _AddClientSuppScreenState();
}

class _AddClientSuppScreenState extends State<AddClientSuppScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController initialBalanceController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    initialBalanceController.dispose();
    super.dispose();
  }

  void _onAdd() {
    final bloc = context.read<ClientSuppBloc>();
    final isValid = nameController.text.trim().isNotEmpty;
    bloc.add(
      AddClientSuppEvent(
        name: nameController.text,
        phoneNumber: phoneController.text,
        gpsLocation: locationController.text,
        initialBalance: initialBalanceController.text,
      ),
    );
    if (!isValid) {
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final entityType = context.watch<ClientSuppBloc>().state.entityType;
    final isNameRequired = context.watch<ClientSuppBloc>().state.isNameRequired;

    return CustomScaffold(
      appBar: CustomAppBar(title: getPageTitle(entityType)),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: 'Name',
              labelText: 'Name',
              maxLength: 30,
              controller: nameController,
              errorBorderColor: isNameRequired ? Colors.red : Colors.white,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9 ]*$'),
                ),
              ],
            ),
            textFieldValidationError(
              requiredParameter: 'Client name is required',
              isValid: !isNameRequired,
            ),
            10.verticalSpace,
            CustomTextFormField(
              hintText: 'Phone Number',
              labelText: 'Phone Number',
              controller: phoneController,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]\d*'),
                ),
              ],
            ),
            10.verticalSpace,
            CustomTextFormField(
              hintText: 'GPS Location (Ex : 36.710382, 3.199882)',
              labelText: 'GPS Location',
              controller: locationController,
              suffixIcon: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  AppAssets.images.gpsIcon,
                  height: 22.h,
                  scale: 2.7,
                ),
              ),
            ),
            10.verticalSpace,
            CustomTextFormField(
              hintText: 'Initial Balance',
              labelText: 'Initial Balance',
              controller: initialBalanceController,
              textInputType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?\d*\.?\d{0,2}'),
                ),
                LengthLimiterInputFormatter(
                  maxIntegerLength: 20,
                  maxDecimalLength: 22,
                ),
              ],
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 20.w),
      bottomNavigationBar: CustomBottomNavBarWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              onTap: _onAdd,
              btnTitle: addBtnTitle(entityType),
            ),
          ],
        ),
      ),
    );
  }

  String getPageTitle(EntityType entityType) =>
      entityType == EntityType.client ? 'Add Client' : 'Add Supplier';

  String addBtnTitle(EntityType entityType) =>
      entityType == EntityType.client ? 'Add Client' : 'Add Supplier';
}
