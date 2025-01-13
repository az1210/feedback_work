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
    this.isLoading = false,
    this.loadingSize,
    this.icon,
    this.iconSize,
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
  final bool isLoading;
  final double? loadingSize;
  final IconData? icon;
  final double? iconSize;

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
    bool isLoading = false,
    double? loadingSize,
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
      isLoading: isLoading,
      loadingSize: loadingSize,
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
    bool isLoading = false,
    double? loadingSize,
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
      isLoading: isLoading,
      loadingSize: loadingSize,
      child: child,
    );
  }

  factory AppButton.text({
    required String label,
    TextStyle? labelTextStyle,
    Color? fgColor,
    double? borderRadius,
    required void Function()? onTap,
    bool isLoading = false,
    double? loadingSize,
  }) {
    return AppButton(
      label: label,
      isFilled: false,
      borderRadius: borderRadius,
      fgColor: fgColor,
      labelTextStyle: labelTextStyle,
      onTap: onTap,
      isLoading: isLoading,
      loadingSize: loadingSize,
      horizontalPadding: 8.w,
    );
  }

  factory AppButton.icon({
    String? label,
    required IconData icon,
    TextStyle? labelTextStyle,
    Color? fgColor,
    double? iconSize,
    double? borderRadius,
    required void Function()? onTap,
    bool isLoading = false,
    double? loadingSize,
  }) {
    return AppButton(
      label: label ?? "",
      isFilled: false,
      borderRadius: borderRadius,
      fgColor: fgColor,
      labelTextStyle: labelTextStyle,
      onTap: onTap,
      icon: icon,
      iconSize: iconSize,
      isLoading: isLoading,
      loadingSize: loadingSize,
      horizontalPadding: 8.w,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor = isFilled
        ? fgColor ?? context.colors.pureWhite
        : fgColor ?? context.colors.primaryBlue;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 16.w,
          vertical: verticalPadding ?? 4.h,
        ),
        decoration: BoxDecoration(
          color: isFilled
              ? bgColor ?? context.colors.primaryBlue
              : context.colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: loadingSize ?? 20.h,
                  width: loadingSize ?? 20.h,
                  child: CircularProgressIndicator(
                    color: foregroundColor,
                    strokeWidth: 2,
                  ),
                ),
              )
            : child ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: iconSize ?? 20.h,
                        color: foregroundColor,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (prefix != null) ...[
                      prefix!,
                      SizedBox(width: 8.w),
                    ],
                    if (label != "") ...[
                      Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: labelTextStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: foregroundColor,
                                      fontSize: 14,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    if (suffix != null) ...[
                      SizedBox(width: 8.w),
                      suffix!,
                    ],
                  ],
                ),
      ),
    );
  }
}
