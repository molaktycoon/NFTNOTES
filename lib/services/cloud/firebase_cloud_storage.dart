import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nftnotes/services/cloud/cloud_note.dart';
import 'cloud_storage_exceptions.dart';
import 'cloud_storage_constant.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNote();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
    .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
.snapshots()
.map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc)));
          return allNotes;
  }
      
//
//We are not using the getNote method
  // Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
  //   try {
  //     return await notes
  //         .where(
  //           ownerUserIdFieldName,
  //           isEqualTo: ownerUserId,
  //         )
  //         .get()
  //         .then(
  //           (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)
  //               //move cod from normal function
  //               // {
  //               //   return CloudNote(
  //               //     documentId: doc.id,
  //               //     ownerUserId: doc.data()[ownerUserIdFieldName] as String,
  //               //     text: doc.data()[textFieldName] as String,
  //               //   );
  //               // },
  //               ),
  //         );
  //   } catch (e) {
  //     throw CouldNotGetAllNotes();
  //   }
  // }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // A singleton creation of FirebaseCloudStorage
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
