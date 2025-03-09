import 'dart:io';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadHelper {
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

        // Upload the file to Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('$folderPath/$fileName');

        final file = File(filePath);
        await storageRef.putFile(file);

        // Get the download URL
        return await storageRef.getDownloadURL();
      }
      return null; // Return null if no file was selected
    } catch (e) {
      Log.error('Error during file pick and upload: $e');
      return null;
    }
  }
}
