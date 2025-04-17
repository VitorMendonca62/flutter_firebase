// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String? id;
  final String title;
  final String content;
  final String author;
  final String authorPhoto;
  int comments;
  int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> photos;
  bool liked;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorPhoto,
    required this.comments,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
    required this.liked,
  });

  static Future<PostModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    return PostModel(
      id: doc.id,
      title: doc['title'],
      content: doc['content'],
      author: doc['author'],
      authorPhoto: doc['authorPhoto'],
      comments: doc['comments'],
      likes: doc['likes'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
      photos: doc['photos'],
      liked: await isLiked(doc),
    );
  }

  static Future<bool> isLiked(DocumentSnapshot doc) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final likeDoc =
        await doc.reference.collection('likes').doc(currentUser!.uid).get();

    return likeDoc.exists;
  }

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
