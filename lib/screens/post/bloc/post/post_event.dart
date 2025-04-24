part of 'post_bloc.dart';

abstract class PostEvent {
  final String postId;
  final bool isRestrict;

  const PostEvent({
    required this.postId,
    required this.isRestrict,
  });
}

class GetPost extends PostEvent {
  const GetPost({
    required super.postId,
    required super.isRestrict,
  });
}

class LikePost extends PostEvent {
  final String type = 'like';
  final PostModel? post;
  final List<CommentModel>? comments;

  const LikePost({
    required super.postId,
    this.post,
    this.comments,
    required super.isRestrict,
  });
}

class UnLikePost extends PostEvent {
  final String type = 'unlike';
  final PostModel? post;
  final List<CommentModel>? comments;

  const UnLikePost({
    required super.postId,
    this.post,
    this.comments,
    required super.isRestrict,
  });
}

class CommentPost extends PostEvent {
  final String content;
  final PostModel? post;
  final List<CommentModel>? comments;
  final int index;

  const CommentPost({
    required super.postId,
    required this.content,
    this.post,
    this.comments,
    required this.index,
    required super.isRestrict,
  });
}

class GetComments extends PostEvent {
  final PostModel? post;

  const GetComments({
    required super.postId,
    this.post,
    required super.isRestrict,
  });
}
