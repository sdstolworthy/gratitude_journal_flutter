import 'package:meta/meta.dart';
import 'package:grateful/src/models/photograph.dart';

@immutable
abstract class ImageHandlerEvent {}

class AddPhotograph extends ImageHandlerEvent {
  AddPhotograph(this.photograph);

  final Photograph photograph;
}

class ReplaceFilePhotoWithNetworkPhoto extends ImageHandlerEvent {
  ReplaceFilePhotoWithNetworkPhoto(
      {@required this.photograph, @required this.filePhotoGuid});

  final String filePhotoGuid;
  final NetworkPhoto photograph;
}

class UploadHasProgress extends ImageHandlerEvent {
  UploadHasProgress({@required this.progress, @required this.photograph});

  final Photograph photograph;
  final double progress;
}

class UploadCompleted extends ImageHandlerEvent {
  UploadCompleted(this.networkPhoto, this.placeholder);

  final NetworkPhoto networkPhoto;
  final FilePhoto placeholder;
}

class SetPhotographs extends ImageHandlerEvent {
  SetPhotographs(this.photographs);

  final List<Photograph> photographs;
}
