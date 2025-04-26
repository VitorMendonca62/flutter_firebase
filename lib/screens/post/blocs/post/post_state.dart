part of 'post_bloc.dart';

abstract class PostState {
  final PostModel? post;
  final List<CommentModel>? comments;
  bool wasHandled;

  PostState(
      {required this.post, required this.comments, required this.wasHandled});
}

class PostInitialState extends PostState {
  PostInitialState({required super.post})
      : super(comments: [], wasHandled: false);
}

class PostLoadingState extends PostState {
  PostLoadingState() : super(post: null, wasHandled: false, comments: []);
}

class PostLoadedState extends PostState {
  PostLoadedState({required super.post, required super.comments})
      : super(wasHandled: false);
}

class PostsFailureState extends PostState {
  final String exception;

  PostsFailureState({required this.exception})
      : super(
          post: null,
          wasHandled: false,
          comments: [],
        );
}
