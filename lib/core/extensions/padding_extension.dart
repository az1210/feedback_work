part of './extensions.dart';

extension PaddingExtension on num {
  SizedBox get ph => SizedBox(height: toDouble().h);
  SizedBox get pw => SizedBox(width: toDouble().w);
}
