import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FileUploadEvent {}

class SubscribeToProgress extends FileUploadEvent {
  SubscribeToProgress(this.uploadTask);

  final StorageUploadTask uploadTask;
}

class UploadCompleted extends FileUploadEvent {
  UploadCompleted(this.imageUrl);

  final String imageUrl;
}

class OnProgress extends FileUploadEvent {
  OnProgress(this.progress);

  final double progress;
}

class BeginFileUpload extends FileUploadEvent {
  BeginFileUpload(this.future);

  final Future<dynamic> future;
}
