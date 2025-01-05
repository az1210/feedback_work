part of './extensions.dart';

extension AppInputDecorExtension on BuildContext {
  AppInputDecorationStyles get inputDecor => AppInputDecorationStyles(this);
}

extension AppColorScheme on BuildContext {
  AppColors get colors => AppColors();
}
