import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/repositories/files/file_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class ImageHandlerBloc extends Bloc<ImageHandlerEvent, ImageHandlerState> {
  ImageHandlerBloc({@required this.fileRepository, @required this.photograph}) {
    if (photograph is FilePhoto) {
      _uploadPhoto(photograph as FilePhoto);
    }
  }

  FileRepository fileRepository;
  Photograph photograph;

  @override
  ImageHandlerState get initialState => InitialImageHandlerState(photograph);

  @override
  Stream<ImageHandlerState> mapEventToState(
    ImageHandlerEvent event,
  ) async* {
    if (event is UploadHasProgress) {
      yield UploadProgress(event.photograph as FilePhoto, event.progress);
    } else if (event is UploadCompleted) {
      yield FileUploaded(event.networkPhoto, event.placeholder);
    } else if (event is UploadHasError) {
      yield ImageUploadError(event.filePhoto);
    }
  }

  bool get isUploaded {
    if (photograph is NetworkPhoto) {
      return true;
    }
    if (state is FileUploaded) {
      return true;
    }
    return false;
  }

  Future<void> _uploadPhoto(FilePhoto filePhoto) async {
    try {
      final StorageUploadTask fileUploadEvent =
          await fileRepository.uploadFile(filePhoto.file);
      final StreamSubscription<StorageTaskEvent> fileUploadSubscription =
          fileUploadEvent.events.listen((StorageTaskEvent eventData) {
        final double uploadProgress = eventData.snapshot.bytesTransferred /
            eventData.snapshot.totalByteCount;
        add(UploadHasProgress(photograph: filePhoto, progress: uploadProgress));
      });

      final StorageTaskSnapshot completedUpload =
          await fileUploadEvent.onComplete;
      final String networkPhotoUrl =
          await completedUpload.ref.getDownloadURL() as String;
      fileUploadSubscription.cancel();

      if (networkPhotoUrl != null) {
        final NetworkPhoto networkPhoto =
            NetworkPhoto(imageUrl: networkPhotoUrl);
        photograph = networkPhoto;
        add(UploadCompleted(networkPhoto, filePhoto));
      }
    } catch (e) {
      add(UploadHasError(filePhoto));
    }
  }
}
