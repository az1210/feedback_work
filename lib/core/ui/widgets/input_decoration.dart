import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInputDecorationStyles {
  const AppInputDecorationStyles(this.context);
  final BuildContext context;
  InputDecoration outlinedInputDecor({
    String? hint,
    void Function()? clearText,
    String? counterText,
    Widget? prefix,
    BorderRadius? borderRadius,
    Widget? suffix,
    Color? focusColor,
    Color? fillColor,
    TextStyle? hintTextStyle,
    String? helperText,
    Widget? label,
    TextStyle? helperTextStyle,
  }) {
    return InputDecoration(
      fillColor: fillColor,
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      counterText: counterText,
      helperText: helperText,
      helperStyle: helperTextStyle,
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(40.r),
        borderSide: BorderSide(
          color: focusColor ?? context.colors.textBlack,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(40.r),
        borderSide: BorderSide(
          color: focusColor ?? context.colors.darkGrey,
        ),
      ),
      hintText: hint,
      hintMaxLines: 2,
      hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: context.colors.darkGrey,
            fontSize: 14.sp,
          ),
      label: label,
      labelStyle: Theme.of(context).textTheme.bodySmall!,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0.04.sw,
        vertical: 0.03.sw,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(40.r),
        borderSide: BorderSide(
          color: context.colors.inputBorder,
        ),
      ),
      errorMaxLines: 4,
    );
  }
}
