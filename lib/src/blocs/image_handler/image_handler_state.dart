import 'package:meta/meta.dart';
import 'package:grateful/src/models/photograph.dart';

@immutable
abstract class ImageHandlerState {
  const ImageHandlerState(this.photograph);

  final Photograph photograph;
}

class InitialImageHandlerState extends ImageHandlerState {
  const InitialImageHandlerState(Photograph photograph) : super(photograph);
}

class FileUploaded extends ImageHandlerState {
  const FileUploaded(NetworkPhoto photograph, this.placeholder)
      : super(photograph);

  final FilePhoto placeholder;
}

class UploadProgress extends ImageHandlerState {
  const UploadProgress(FilePhoto filePhoto, this.fileProgress) : super(filePhoto);

  final double fileProgress;
}
