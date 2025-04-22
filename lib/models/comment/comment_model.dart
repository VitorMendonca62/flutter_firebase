// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String content;
  final String author;
  final String authorPhoto;
  final DateTime createdAt;

  CommentModel({
    required this.content,
    required this.author,
    required this.authorPhoto,
    required this.createdAt,
  });

  static Future<CommentModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    print(doc.data() );
    return CommentModel(
      content: doc['content'],
      author: doc['author'],
      authorPhoto: doc['authorPhoto'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
