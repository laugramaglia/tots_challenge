import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_avatar.g.dart';

@riverpod
class SelectAvatar extends _$SelectAvatar {
  @override
  Future<File?> build() async {
    // Initial state with an empty list of selected file paths
    return await Future.value(null);
  }

  Future<void> pickFiles() async {
    try {
      // Open file picker for image selection
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Restrict to images only
        allowMultiple: false, // Single image selection
        onFileLoading: (status) => log(status.toString()),
        // Optional compression
        compressionQuality: 30,
      );

      // Check if user picked files
      if (result != null && result.files.isNotEmpty) {
        // Update the state with the file paths
        final filePath = result.files.first.path;
        if (filePath != null) {
          // Update the state with the selected file
          state = AsyncValue.data(File(filePath));
        } else {
          state = const AsyncValue.data(null);
        }
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation: ${e.toString()}');
      state = AsyncValue.error(
          'Unsupported operation: ${e.toString()}', StackTrace.current);
    } catch (e) {
      _logException(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  void _logException(String message) {
    log(message);
  }
}
