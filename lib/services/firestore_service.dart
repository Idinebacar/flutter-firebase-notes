import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get notes => _firestore.collection('notes');

  // Save a new note.
  Future<void> addNote({
    required String title,
    required String content,
    int color = 0xFFFFFFFF,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to save a note.');
    }

    await notes.add({
      "title": title,
      "content": content,
      "userId": user.uid,
      "color": color,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // Load notes for the signed-in user in real time.
  Stream<QuerySnapshot> getNotes() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    // Show the newest notes first.
    return notes
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // Update an existing note.
  Future<void> updateNote({
    required String docId,
    required String title,
    required String content,
    int? color,
  }) async {
    final Map<String, dynamic> data = {
      "title": title,
      "content": content,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (color != null) {
      data["color"] = color;
    }

    await notes.doc(docId).update(data);
  }

  // Remove a note.
  Future<void> deleteNote(String docId) async {
    await notes.doc(docId).delete();
  }
}
