// lib/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String? id;
  final String title;
  final String content;
  final String author;
  final int comments;
  final int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> photos;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
    required this.likes,
    required this.comments,
  });

  factory PostModel.fromDocumentSnapshot(doc) {
    return PostModel(
      id: doc.id,
      title: doc['title'],
      content: doc['content'],
      author: doc['author'],
      comments: int.parse(doc['comments']),
      likes: int.parse(doc['likes']),
      createdAt: DateTime.parse(doc['createdAt']),
      updatedAt: DateTime.parse(doc['updatedAt']),
      photos: doc['photos'],
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
