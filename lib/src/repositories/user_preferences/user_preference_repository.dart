import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grateful/src/config/constants.dart';
import 'package:grateful/src/models/preferences/daily_notification.dart';
import 'package:grateful/src/models/preferences/language_settings.dart';
import 'package:grateful/src/models/preferences/user_preference.dart';

class UserPreferenceRepository {
  static const _userCollectionName = Constants.userRepositoryName;
  static const _preferenceCollectionName = 'preferences';

  static const _languagePreferenceDocument = 'language';

  static const _notificationPreferenceDocument = 'notifications';

  FirebaseAuth _firebaseAuth;

  Firestore firestore;

  UserPreferenceRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        this.firestore = firestore ?? Firestore.instance;

  Future<UserPreferenceSettings> updateUserPreference<T extends UserPreference>(
      UserPreference preference) async {
    DocumentReference documentReference;
    if (preference.runtimeType == UserLanguageSettings) {
      documentReference =
          await _getDocumentReference(_languagePreferenceDocument);
    } else if (preference.runtimeType == DailyJournalReminderSettings) {
      documentReference =
          await _getDocumentReference(_notificationPreferenceDocument);
    } else {
      return null;
    }
    if (documentReference == null) {
      return null;
    }
    await documentReference.setData(preference.toMap(), merge: true);
    return getUserSettings();
  }

  Future<DocumentReference> _getDocumentReference(String documentName) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    return firestore
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_preferenceCollectionName)
        .document(documentName);
  }

  UserPreferenceSettings _serializeDocumentsToUserPreferences(
      List<DocumentSnapshot> documents) {
    UserPreferenceSettings userPreferenceSettings = UserPreferenceSettings();

    documents.forEach((document) {
      if (document.documentID == _languagePreferenceDocument) {
        userPreferenceSettings.userLanguageSettings =
            UserLanguageSettings.fromMap(document.data);
      } else if (document.documentID == _notificationPreferenceDocument) {
        userPreferenceSettings.dailyJournalReminderSettings =
            DailyJournalReminderSettings.fromMap(document.data);
      }
    });

    return userPreferenceSettings;
  }

  Future<UserPreferenceSettings> getUserSettings() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    final documents = await firestore
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_preferenceCollectionName)
        .getDocuments();

    final settings =
        _serializeDocumentsToUserPreferences(documents.documents.toList());

    return settings;
  }
}
