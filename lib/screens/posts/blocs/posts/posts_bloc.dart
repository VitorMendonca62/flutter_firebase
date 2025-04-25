import 'dart:async';

import '../../repositories/posts_repository.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc {
  final _postsRepository = PostsRepository();

  final StreamController<PostsEvent> _postsControllerInput =
      StreamController<PostsEvent>();
  final StreamController<PostsState> _postsControllerOutput =
      StreamController<PostsState>();

  Sink<PostsEvent> get postsInput => _postsControllerInput.sink;
  Stream<PostsState> get postsOutput => _postsControllerOutput.stream;

  PostsBloc() {
    _postsControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PostsEvent event) async {
    try {
      if (!(event is LikePost || event is UnLikePost)) {
        _postsControllerOutput.add(PostsLoadingState());
      }

      if (event is GetPosts) {
        List<PostModel>? posts = await _postsRepository
            .getAll(
              event.isRestrict,
            )
            ?.first;
        _postsControllerOutput.add(PostsLoadedState(posts: posts ?? []));
      }

      if (event is LikePost) {
        await _postsRepository.changeLikePost(
          event.postId,
          event.type,
          event.isRestrict,
        );
        _postsControllerOutput.add(PostsLoadedState(posts: event.posts));
      }

      if (event is UnLikePost) {
        await _postsRepository.changeLikePost(
          event.postId,
          event.type,
          event.isRestrict,
        );
        _postsControllerOutput.add(PostsLoadedState(posts: event.posts));
      }

      // if (event is PostPost) {
      //   await _postsRepository.createPost();
      //   _postsControllerOutput.add(PostCreateState());
      // }
    } catch (e) {
      _postsControllerOutput.add(PostsFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
