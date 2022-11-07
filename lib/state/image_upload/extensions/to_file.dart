import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File;

extension ToFile on Future<XFile?> {
  // use this if you do not understand => this.then((xFile))

  Future<File?> toFile() => then((xFile) => xFile?.path)
      .then((filePath) => filePath != null ? File(filePath) : null);
}
