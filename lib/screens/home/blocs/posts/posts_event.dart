part of 'posts_bloc.dart';

abstract class PostsEvent {}

class GetPosts extends PostsEvent {}

class PostPost extends PostsEvent {
  final PostModel post;

  PostPost({
    required this.post,
  });
}

class LikePost extends PostsEvent {
  final String postId;
  final String type = 'like';
  final List<PostModel> posts;

  LikePost({
    required this.postId,
    required this.posts,
  });
}

class UnLikePost extends PostsEvent {
  final String postId;
  final String type = 'unlike';
  final List<PostModel> posts;

  UnLikePost({
    required this.postId,
    required this.posts,
  });
}
