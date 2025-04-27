// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      authorId: json['authorId'] as String,
      authorPhoto: json['authorPhoto'] as String,
      comments: (json['comments'] as num).toInt(),
      likes: (json['likes'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      photos: json['photos'] as List<dynamic>,
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'authorId': instance.authorId,
      'authorPhoto': instance.authorPhoto,
      'comments': instance.comments,
      'likes': instance.likes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'photos': instance.photos,
      'liked': instance.liked,
    };
