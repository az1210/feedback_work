import 'package:dotted_border/dotted_border.dart';
import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class DottedBorderBigButton extends StatelessWidget {
  const DottedBorderBigButton({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String? title;
  final void Function()? onTap;
  final Widget? icon;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          color: Colors.grey,
          strokeWidth: 1,
          dashPattern: const [8, 8],
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
            child: Column(
              children: [
                if (icon != null) ...[
                  Center(child: icon!),
                  const SizedBox(height: 8),
                ],
                if (title != null) ...[
                  Text(
                    title ?? 'Upload the file here',
                    style: titleStyle ??
                        TextStyle(color: context.colors.primaryBlue),
                  ),
                  const SizedBox(height: 4),
                ],
                if (subtitle != null) ...[
                  Center(
                    child: Text(
                      subtitle!,
                      style: subtitleStyle ??
                          TextStyle(
                            color: context.colors.darkGrey,
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
