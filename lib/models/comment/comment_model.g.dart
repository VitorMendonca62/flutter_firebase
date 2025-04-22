// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      content: json['content'] as String,
      author: json['author'] as String,
      authorPhoto: json['authorPhoto'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'author': instance.author,
      'authorPhoto': instance.authorPhoto,
      'createdAt': instance.createdAt.toIso8601String(),
    };
