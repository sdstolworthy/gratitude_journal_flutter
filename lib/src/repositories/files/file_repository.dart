import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  FileRepository({this.storageBucketUrl}) {
    _storage = FirebaseStorage(storageBucket: storageBucketUrl);
  }

  final String storageBucketUrl;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage _storage;

  Future<StorageUploadTask> uploadFile(File file) async {
    final String userId = (await _firebaseAuth.currentUser()).uid;
    final String filePath = 'images/$userId/${Uuid().v4()}.png';
    final StorageReference storageRef = _storage.ref().child(filePath);
    return storageRef.putFile(file);
  }
}
