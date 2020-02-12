import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc({@required this.uploadTask});

  final StorageUploadTask uploadTask;

  @override
  FileUploadState get initialState => InitialFileUploadState();

  @override
  Stream<FileUploadState> mapEventToState(
    FileUploadEvent event,
  ) async* {
    if (event is SubscribeToProgress) {
      event?.uploadTask?.events?.listen((StorageTaskEvent d) {
        final double progress =
            d.snapshot.bytesTransferred / d.snapshot.totalByteCount;
        if (progress == 1) {
          return;
        }
        add(OnProgress(progress));
      });
      event?.uploadTask?.onComplete?.then((StorageTaskSnapshot d) async {
        final String imageUrl = await d.ref.getDownloadURL() as String;
        add(UploadCompleted(imageUrl));
      });
    } else if (event is OnProgress) {
      yield FileUploadProgress(event.progress);
    } else if (event is UploadCompleted) {
      yield UploadSuccess(event.imageUrl);
    }
  }
}
