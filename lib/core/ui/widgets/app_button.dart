import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.labelTextStyle,
    this.bgColor,
    this.fgColor,
    this.borderRadius,
    this.isFilled = true,
    this.borderColor,
    this.onTap,
    this.child,
    this.prefix,
    this.suffix,
    this.horizontalPadding,
    this.verticalPadding,
    this.height,
    this.width,
  });

  final String label;
  final TextStyle? labelTextStyle;
  final Color? bgColor;
  final Color? fgColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool isFilled;
  final Color? borderColor;
  final void Function()? onTap;
  final Widget? child;
  final Widget? prefix;
  final Widget? suffix;

  factory AppButton.filled({
    required String label,
    TextStyle? labelTextStyle,
    Color? bgColor,
    Color? fgColor,
    double? height,
    double? width,
    double? borderRadius,
    double? horizontalPadding,
    double? verticalPadding,
    Color? borderColor,
    required void Function()? onTap,
    Widget? child,
    Widget? prefix,
    Widget? suffix,
  }) {
    return AppButton(
      label: label,
      bgColor: bgColor,
      fgColor: fgColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      horizontalPadding: horizontalPadding,
      labelTextStyle: labelTextStyle,
      onTap: onTap,
      prefix: prefix,
      suffix: suffix,
      verticalPadding: verticalPadding,
      child: child,
    );
  }
  factory AppButton.outlined({
    required String label,
    TextStyle? labelTextStyle,
    Color? fgColor,
    double? height,
    double? width,
    double? borderRadius,
    double? horizontalPadding,
    double? verticalPadding,
    Color? borderColor,
    required void Function()? onTap,
    Widget? child,
    Widget? prefix,
    Widget? suffix,
  }) {
    return AppButton(
      label: label,
      isFilled: false,
      borderColor: borderColor,
      height: height,
      width: width,
      borderRadius: borderRadius,
      fgColor: fgColor,
      horizontalPadding: horizontalPadding,
      labelTextStyle: labelTextStyle,
      prefix: prefix,
      onTap: onTap,
      suffix: suffix,
      verticalPadding: verticalPadding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticalPadding ?? 4.h,
        ),
        decoration: BoxDecoration(
          color: isFilled
              ? bgColor ?? context.colors.primaryBlue
              : context.colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefix ?? const SizedBox.shrink(),
                Text(
                  label,
                  style: labelTextStyle ??
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isFilled
                                ? fgColor ?? context.colors.pureWhite
                                : fgColor ?? context.colors.primaryBlue,
                          ),
                ),
                suffix ?? const SizedBox.shrink(),
              ],
            ),
      ),
    );
  }
}
