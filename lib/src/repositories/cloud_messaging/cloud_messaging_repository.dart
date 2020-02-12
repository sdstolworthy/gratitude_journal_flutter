import 'package:cloud_firestore/cloud_firestore.dart';

class CloudMessagingRepository {
  final String _firebaseSettings = 'settings';
  final String _firebaceCloudStoreDocumentName = 'fcm';
  final String _firebaseTokens = 'tokens';
  Future<void> setId(String id) async {
    await Firestore.instance
        .collection(_firebaseSettings)
        .document(_firebaceCloudStoreDocumentName)
        .setData(<String, dynamic>{
      _firebaseTokens: FieldValue.arrayUnion(<String>[id]),
    }, merge: true);
  }
}
