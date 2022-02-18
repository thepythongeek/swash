import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'file_to_upload.dart';
import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';

class FileManager extends ChangeNotifier {
  XFile? _xfile;
  File? _file;
  bool _video = false;

  XFile? get xfile => _xfile;
  File? get file => _file;

  get video => _video;

  void addFile(File file) {
    _file = file;
    notifyListeners();
  }

  void addXFile(XFile file) {
    _xfile = file;
    notifyListeners();
  }

  void showVideo() {
    _video = !_video;
  }

  void reset() {
    _file = null;
    _xfile = null;
    _video = false;
    notifyListeners();
  }
}
