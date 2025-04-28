part of 'posts_bloc.dart';

abstract class PostsEvent {
  final bool isRestrict;

  const PostsEvent({
    this.isRestrict = false,
  });
}

class GetPosts extends PostsEvent {
  const GetPosts({
    super.isRestrict,
  });
}

class LogoutEvent extends PostsEvent {
  const LogoutEvent({
    super.isRestrict,
  });
}

class PostPost extends PostsEvent {
  final PostModel post;

  const PostPost({
    required this.post,
    super.isRestrict,
  });
}

class LikePost extends PostsEvent {
  final String postId;
  final String type = 'like';
  final List<PostModel> posts;

  const LikePost({
    required this.postId,
    required this.posts,
    super.isRestrict,
  });
}

class UnLikePost extends PostsEvent {
  final String postId;
  final String type = 'unlike';
  final List<PostModel> posts;

  const UnLikePost({
    required this.postId,
    required this.posts,
    super.isRestrict,
  });
}
