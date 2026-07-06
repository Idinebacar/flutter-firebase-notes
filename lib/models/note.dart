import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userId;
  final int color;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.color = 0xFFFFFFFF,
  });

  // Turn a Firestore item into a note object.
  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
      color: data['color'] ?? 0xFFFFFFFF,
    );
  }

  // Turn a note object into a map so it can be saved in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'userId': userId,
      'color': color,
    };
  }
}
