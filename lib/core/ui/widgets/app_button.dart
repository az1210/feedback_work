import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.labelTextStyle,
    required this.bgColor,
    required this.fgColor,
    this.borderRadius,
    required this.isFilled,
    this.borderColor,
    this.onTap,
    this.child,
    this.prefix,
    this.suffix,
    this.horizontalPadding,
    this.verticalPadding,
  });

  final String label;
  final TextStyle? labelTextStyle;
  final Color bgColor;
  final Color fgColor;
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool isFilled;
  final Color? borderColor;
  final void Function()? onTap;
  final Widget? child;
  final Widget? prefix;
  final Widget? suffix;

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
          color: bgColor,
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
                      Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: fgColor),
                ),
                suffix ?? const SizedBox.shrink(),
              ],
            ),
      ),
    );
  }
}
