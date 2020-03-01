import 'dart:io';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grateful/src/blocs/image_handler/bloc.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/repositories/files/file_repository.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

class MockStorageUploadTask extends Mock implements StorageUploadTask {}

class MockFile extends Mock implements File {}

class FirebaseStorageMock extends Mock implements FirebaseStorage {}

class StorageReferenceMock extends Mock implements StorageReference {}

class StorageTaskSnapshotMock extends Mock implements StorageTaskSnapshot {}

void main() {
  group('File Upload Bloc:', () {
    MockFileRepository fileRepository;
    FilePhoto filePhoto;
    MockFile file;
    ImageHandlerBloc imageHandlerBloc;
    MockStorageUploadTask storageUploadTask;
    StorageTaskSnapshot storageTaskSnapshot;
    StorageReferenceMock storageReferenceMock;

    void instantiateImageHandlerBloc() {
      imageHandlerBloc = ImageHandlerBloc(
          fileRepository: fileRepository, photograph: filePhoto);
    }

    void mockValidUpload() {
      when(storageUploadTask.events).thenAnswer(
          (_) => Stream<StorageTaskEvent>.fromIterable(<StorageTaskEvent>[]));
      when(storageUploadTask.onComplete)
          .thenAnswer((_) async => storageTaskSnapshot);
      when(storageTaskSnapshot.ref).thenReturn(storageReferenceMock);
      when(fileRepository.uploadFile(filePhoto.file)).thenAnswer(
          (_) => Future<StorageUploadTask>.value(storageUploadTask));
      instantiateImageHandlerBloc();
    }

    void mockErrorUpload() {
      when(fileRepository.uploadFile(file)).thenThrow(() => Error());
      instantiateImageHandlerBloc();
    }

    setUp(() {
      fileRepository = MockFileRepository();
      file = MockFile();
      filePhoto = FilePhoto(file: file);
      storageUploadTask = MockStorageUploadTask();
      storageTaskSnapshot = StorageTaskSnapshotMock();
      storageReferenceMock = StorageReferenceMock();
    });

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Initial state is InitialImageHandlerState',
        skip: 0, build: () async {
      mockValidUpload();
      return imageHandlerBloc;
    }, expect: <TypeMatcher<dynamic>>[isA<InitialImageHandlerState>()]);

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Bloc returns uploadprogress',
        skip: 0,
        build: () {
          mockValidUpload();
          instantiateImageHandlerBloc();
          return Future<ImageHandlerBloc>.value(imageHandlerBloc);
        },
        expect: <TypeMatcher<dynamic>>[
          isA<InitialImageHandlerState>(),
          isA<UploadProgress>()
        ],
        act: (ImageHandlerBloc bloc) async => bloc.add(UploadHasProgress(
            photograph: FilePhoto(file: null), progress: 0.1)));

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Bloc returns error when _uploadPhoto fails',
        skip: 0, build: () {
      mockErrorUpload();
      return Future<ImageHandlerBloc>.value(imageHandlerBloc);
    }, expect: <TypeMatcher<dynamic>>[
      isA<InitialImageHandlerState>(),
      isA<ImageUploadError>()
    ]);
  });
}
