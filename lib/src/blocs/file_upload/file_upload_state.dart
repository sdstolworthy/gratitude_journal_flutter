import 'package:meta/meta.dart';

@immutable
abstract class FileUploadState {}

class InitialFileUploadState extends FileUploadState {}

class FileUploadProgress extends FileUploadState {
  FileUploadProgress(this.progress);

  final double progress;
}

class UploadSuccess extends FileUploadState {
  UploadSuccess(this.imageUrl);

  final String imageUrl;
}

class UploadError extends FileUploadState {}
