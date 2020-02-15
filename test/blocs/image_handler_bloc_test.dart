import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grateful/src/blocs/image_handler/bloc.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/repositories/files/file_repository.dart';
import 'package:mockito/mockito.dart';

class MockFileRepository extends Mock implements FileRepository {}

class MockFile extends Mock implements File {}

void main() {
  group('File Upload Bloc', () {
    MockFileRepository fileRepository;
    FilePhoto filePhoto;
    MockFile file;
    ImageHandlerBloc imageHandlerBloc;

    setUp(() {
      fileRepository = MockFileRepository();
      file = MockFile();
      filePhoto = FilePhoto(file: file);

      imageHandlerBloc = ImageHandlerBloc(
          fileRepository: fileRepository, photograph: filePhoto);
    });

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Initial state is InitialImageHandlerState',
        build: () => imageHandlerBloc,
        expect: <TypeMatcher<dynamic>>[isA<InitialImageHandlerState>()]);

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Bloc returns uploadprogress',
        build: () {
          when(fileRepository.uploadFile(null))
              .thenAnswer((_) => Future<StorageUploadTask>.value(null));
          return imageHandlerBloc;
        },
        expect: <TypeMatcher<dynamic>>[
          isA<InitialImageHandlerState>(),
          isA<UploadProgress>()
        ],
        act: (ImageHandlerBloc bloc) async => bloc.add(UploadHasProgress(
            photograph: FilePhoto(file: null), progress: 0.1)));

    blocTest<ImageHandlerBloc, ImageHandlerEvent, ImageHandlerState>(
        'Bloc returns error when _uploadPhoto fails', build: () {
      when(fileRepository.uploadFile(file)).thenThrow(() => Error());
      return imageHandlerBloc;
    }, expect: <TypeMatcher<dynamic>>[
      isA<InitialImageHandlerState>(),
      isA<ImageUploadError>()
    ]);
  });
}
