part of 'post_bloc.dart';

abstract class PostEvent {}

class GetPost extends PostEvent {
  final String postId;

  GetPost({
    required this.postId,
  });
}

class LikePost extends PostEvent {
  final String postId;
  final String type = 'like';
  final PostModel? post;
  final List<CommentModel>? comments;

  LikePost({
    required this.postId,
    required this.post,
    required this.comments,
  });
}

class UnLikePost extends PostEvent {
  final String postId;
  final String type = 'unlike';
  final PostModel? post;
  final List<CommentModel>? comments;

  UnLikePost({
    required this.postId,
    required this.post,
    required this.comments,
  });
}

class CommentPost extends PostEvent {
  final String postId;
  final String content;
  final PostModel? post;
  final List<CommentModel>? comments;
  final int index;

  CommentPost({
    required this.postId,
    required this.content,
    required this.post,
    required this.comments,
    required this.index,
  });
}

class GetComments extends PostEvent {
  final String postId;
  final PostModel? post;

  GetComments({
    required this.postId,
    required this.post,
  });
}
