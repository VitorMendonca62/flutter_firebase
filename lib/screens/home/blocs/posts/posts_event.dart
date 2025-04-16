part of 'posts_bloc.dart';

abstract class PostsEvent {}

class GetPosts extends PostsEvent {}

class PostPost extends PostsEvent {
  final PostModel post;

  PostPost({
    required this.post,
  });
}

class LikePost extends PostsEvent {}

class UnLikePost extends PostsEvent {}
