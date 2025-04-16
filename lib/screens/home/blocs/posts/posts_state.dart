part of 'posts_bloc.dart';

abstract class PostsState {
  final List<PostModel> posts;
  bool wasHandled;

  PostsState({required this.posts, required this.wasHandled});
}

class PostsInitialState extends PostsState {
  PostsInitialState() : super(posts: [], wasHandled: false);
}

class PostsLoadingState extends PostsState {
  PostsLoadingState() : super(posts: [], wasHandled: false);
}

class PostCreateState extends PostsState {
  PostCreateState() : super(posts: [], wasHandled: false);
}

class PostsLoadedState extends PostsState {
  PostsLoadedState({required super.posts}) : super(wasHandled: false);
}

class PostsFailureState extends PostsState {
  final String exception;

  PostsFailureState({required this.exception})
      : super(posts: [], wasHandled: false);
}
