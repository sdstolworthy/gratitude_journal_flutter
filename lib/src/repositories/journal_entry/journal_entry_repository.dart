import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grateful/src/config/constants.dart';
import 'package:grateful/src/models/journal_entry.dart';

class JournalEntryRepository {
  JournalEntryRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const String _itemCollectionName = 'journal_entries';
  static const String _userCollectionName = Constants.userRepositoryName;

  final FirebaseAuth _firebaseAuth;

  Future<List<JournalEntry>> getFeed(
      {int take = 50, int limit = 50, int skip = 50}) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) {
      return null;
    }
    final List<DocumentSnapshot> entries = (await Firestore.instance
            .collection(_userCollectionName)
            .document(user.uid)
            .collection(_itemCollectionName)
            .getDocuments())
        .documents
        .where((DocumentSnapshot d) => !(d.data['deleted'] == true))
        .toList();
    return entries.isEmpty
        ? <JournalEntry>[]
        : entries
            .map(
              (DocumentSnapshot entry) => JournalEntry.fromMap(entry.data),
            )
            .toList();
  }

  Future<JournalEntry> saveItem(JournalEntry journalEntry) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(journalEntry.id.toString())
        .setData(journalEntry.toMap());
    return journalEntry;
  }

  Future<void> deleteItem(JournalEntry journalEntry) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance
        .collection(_userCollectionName)
        .document(user.uid)
        .collection(_itemCollectionName)
        .document(journalEntry.id.toString())
        .updateData(<String, dynamic>{'deleted': true});
  }
}
