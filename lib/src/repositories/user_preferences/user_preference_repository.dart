import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grateful/src/config/constants.dart';
import 'package:grateful/src/models/preferences/user_preference.dart';

class UserPreferenceRepository {
  static const _userCollectionName = Constants.userRepositoryName;
  static const _preferenceCollectionName = 'preferences';

  FirebaseAuth _firebaseAuth;

  Firestore firestore;

  UserPreferenceRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        this.firestore = firestore ?? Firestore.instance;

  Future<UserPreferenceSettings> updateUserSettings(
      UserPreferenceSettings settings) async {
    final documentReference = await _getDocumentReference();
    final settingsDocument = await documentReference.get();
    if (settingsDocument.data != null) {
      await documentReference.setData(settings.toMap(), merge: true);
    } else {
      await documentReference.setData(settings.toMap());
    }
    return getUserSettings();
  }

  Future<DocumentReference> _getDocumentReference() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    return firestore
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_preferenceCollectionName)
        .document(_preferenceCollectionName);
  }

  Future<UserPreferenceSettings> getUserSettings() async {
    return UserPreferenceSettings.fromMap(
        (await (await _getDocumentReference()).get()).data);
  }
}
