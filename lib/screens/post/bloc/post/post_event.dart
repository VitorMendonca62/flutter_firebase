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

  LikePost({
    required this.postId,
    required this.post,
  });
}

class UnLikePost extends PostEvent {
  final String postId;
  final String type = 'unlike';
  final PostModel? post;

  UnLikePost({
    required this.postId,
    required this.post,
  });
}
