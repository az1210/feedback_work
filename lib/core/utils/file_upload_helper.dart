import 'dart:io';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileUploadHelper {
  static final supabase = Supabase.instance.client;

  /// Picks a file and uploads it to Firebase Storage, returning the file's download URL.
  static Future<String?> pickAndUploadFile({
    String folderPath = "project_images",
    List<String> allowedExtensions = const ['jpg', 'png', 'pdf', 'webp'],
  }) async {
    try {
      // Pick a file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = filePath.split('/').last;
        final file = File(filePath);

        await supabase.storage.from(folderPath).upload(fileName, file);
        return supabase.storage.from(folderPath).getPublicUrl(fileName);
      }
      return null; // Return null if no file was selected
    } catch (e) {
      Log.error('Error during file pick and upload: $e');
      return null;
    }
  }
}
