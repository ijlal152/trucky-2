import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final double height;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color errorBorderColor;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText = '',
    this.labelText,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.height = 70,
    this.inputFormatters,
    this.validator,
    this.contentPadding,
    this.onEditingComplete,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.errorBorderColor = Colors.white,
    this.onChanged,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.sentences,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: enabled ? errorBorderColor : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadiusDirectional.circular(8.r),
        ),
        child: Container(
          color: enabled ? Colors.white : Colors.grey[200],
          alignment: Alignment.center,
          child: TextFormField(
            enabled: enabled,
            showCursor: enabled && !readOnly,
            readOnly: readOnly,
            onTap: enabled ? onTap : null,
            textCapitalization: textCapitalization,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: enabled ? Colors.black : Colors.grey,
            ),
            maxLength: maxLength,
            controller: controller,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: enabled ? onChanged : null,
            onEditingComplete: enabled ? onEditingComplete : null,
            onFieldSubmitted: enabled ? onFieldSubmitted : null,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hintText,
              labelText: labelText,
              labelStyle: TextStyle(
                color: enabled
                    ? const Color.fromRGBO(92, 97, 111, 1)
                    : Colors.grey,
                fontSize: 17.sp,
                fontFamily: FontConstants.inter,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(
                  4,
                  12,
                  34,
                  1,
                ).withValues(alpha: 0.6),
              ),
              contentPadding: contentPadding,
              fillColor: enabled ? fillColor : Colors.grey[200],
              filled: true,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class MultiLineTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? textInputType;
  final double height;

  const MultiLineTextFormField({
    super.key,
    this.controller,
    this.height = 128,
    this.hintText,
    this.textInputType = TextInputType.multiline,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(8.r),
        ),
        child: Container(
          color: Colors.white,
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              labelText: labelText,
              labelStyle: TextStyle(
                color: const Color.fromRGBO(92, 97, 111, 1),
                fontSize: 17.sp,
                fontFamily: FontConstants.inter,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(
                  4,
                  12,
                  34,
                  1,
                ).withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentSheetTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final double height;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color errorBorderColor;
  final FocusNode? focusNode;

  const ContentSheetTextField({
    super.key,
    this.controller,
    this.hintText = '',
    this.labelText,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.height = 70,
    this.inputFormatters,
    this.validator,
    this.contentPadding,
    this.onEditingComplete,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.errorBorderColor = Colors.white,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: errorBorderColor, width: 1),
          borderRadius: BorderRadiusDirectional.circular(8.r),
        ),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: TextFormField(
            focusNode: focusNode,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            controller: controller,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            validator: validator,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hintText,
              labelText: labelText,
              labelStyle: TextStyle(
                color: const Color.fromRGBO(92, 97, 111, 1),
                fontSize: 17.sp,
                fontFamily: FontConstants.inter,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(
                  4,
                  12,
                  34,
                  1,
                ).withValues(alpha: 0.6),
              ),
              contentPadding: contentPadding,
              fillColor: fillColor,
              filled: true,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class LengthLimiterInputFormatter extends TextInputFormatter {
  final int maxIntegerLength;
  final int maxDecimalLength;

  LengthLimiterInputFormatter({
    required this.maxIntegerLength,
    required this.maxDecimalLength,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.contains('.')) {
      if (text.length > maxDecimalLength) {
        return oldValue;
      }
    } else {
      if (text.length > maxIntegerLength) {
        return oldValue;
      }
    }

    return newValue;
  }
}
