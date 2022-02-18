import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

class CompressionError implements Exception {
  final String message;
  CompressionError(this.message);
}

class FileStillBig extends CompressionError {
  FileStillBig(String message) : super(message);
}

Future<int?> getVideoSize(XFile file) async {
  final info = await VideoCompress.getMediaInfo(file.path);
  return info.filesize;
}

Future<MediaInfo?> compress(XFile file) async {
  return await VideoCompress.compressVideo(file.path,
      quality: VideoQuality.MediumQuality, deleteOrigin: false);
}

/// checks whether video file is too big
/// than the limit specified and tries to compressing
/// returns an error if the file is still too big
Future<File> uploadVideo(XFile file, {int maxSize: 6000000}) async {
  int? size = await getVideoSize(file);
  if (size == null) {
    throw CompressionError('Could not get file size');
  }
  if (size < maxSize) {
    return File(file.path);
  }
  final info = await compress(file);
  if (info == null) {
    throw CompressionError('cannot compress this file');
  }
  if (info.filesize! < maxSize) {
    return info.file!;
  }
  throw FileStillBig('file still too big');
}
