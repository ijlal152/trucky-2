import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/settings/widgets/already_have_an_account_widget.dart';
import 'package:trucky/presentation/settings/widgets/password_validation_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/custom_text_form_field.dart';

class EditPasswordScreen extends StatefulWidget {
  static const String id = '/settings/edit-password';

  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordObscured = true;
  bool _newPasswordObscured = true;
  bool _confirmPasswordObscured = true;

  bool _isValidPasswordLength = false;
  bool _hasUppercaseSymbol = false;
  bool _hasANumber = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final value = _newPasswordController.text;
    setState(() {
      _isValidPasswordLength = value.length >= 8;
      _hasUppercaseSymbol = value.contains(RegExp(r'[A-Z]|[^a-zA-Z0-9]'));
      _hasANumber = value.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Edit Password'),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: _passwordController,
              hintText: 'Current Password',
              labelText: 'Current Password',
              obscureText: _passwordObscured,
              suffixIcon: InkWell(
                onTap: () => setState(() => _passwordObscured = !_passwordObscured),
                child: Icon(
                  _passwordObscured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            10.verticalSpace,
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: 'New Password',
              labelText: 'New Password',
              obscureText: _newPasswordObscured,
              suffixIcon: InkWell(
                onTap: () =>
                    setState(() => _newPasswordObscured = !_newPasswordObscured),
                child: Icon(
                  _newPasswordObscured ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            10.verticalSpace,
            CustomTextFormField(
              controller: _confirmPasswordController,
              obscureText: _confirmPasswordObscured,
              hintText: 'Confirm New Password',
              labelText: 'Confirm New Password',
              suffixIcon: InkWell(
                onTap: () => setState(
                  () => _confirmPasswordObscured = !_confirmPasswordObscured,
                ),
                child: Icon(
                  _confirmPasswordObscured
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            20.verticalSpace,
            PasswordValidationWidget(
              isValidPasswordLength: _isValidPasswordLength,
              hasUppercaseSymbol: _hasUppercaseSymbol,
              hasANumber: _hasANumber,
            ),
            20.verticalSpace,
            AlreadyHaveAnAccountWidget(
              btnText: 'Click here',
              text: 'Forgot Password ?',
              onTap: () {},
            ),
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
      bottomNavigationBar: CustomBottomNavBarWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              onTap: () {},
              btnTitle: 'Continue',
              isDisabled: true,
            ),
          ],
        ),
      ),
    );
  }
}