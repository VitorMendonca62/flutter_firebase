import 'dart:async';

import 'package:flutter_firebase/models/comment/comment_model.dart';

import '../../repositories/post_repository.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc {
  final _postRepository = PostRepository();

  final StreamController<PostEvent> _postControllerInput =
      StreamController<PostEvent>();
  final StreamController<PostState> _postControllerOutput =
      StreamController<PostState>();

  Sink<PostEvent> get postInput => _postControllerInput.sink;
  Stream<PostState> get postOutput => _postControllerOutput.stream;

  PostBloc() {
    _postControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PostEvent event) async {
    try {
      if (!(event is LikePost || event is UnLikePost)) {
        _postControllerOutput.add(PostLoadingState());
      }

      if (event is LikePost) {
        await _postRepository.changeLikePost(
          event.postId,
          event.type,
          event.isRestrict,
        );
        _postControllerOutput.add(PostLoadedState(
          post: event.post,
          comments: event.comments,
        ));
      }

      if (event is UnLikePost) {
        await _postRepository.changeLikePost(
          event.postId,
          event.type,
          event.isRestrict,
        );
        _postControllerOutput
            .add(PostLoadedState(post: event.post, comments: event.comments));
      }

      if (event is CommentPost) {
        final model = await _postRepository.addComment(
          event.postId,
          event.content,
          event.index,
          event.isRestrict,
        );
        event.comments?.insert(0, model);
        _postControllerOutput.add(PostLoadedState(
          post: event.post,
          comments: event.comments,
        ));
      }

      if (event is GetComments) {
        Stream<List<CommentModel>?>? commentsStream =
            await _postRepository.getComments(event.postId, event.isRestrict);
        List<CommentModel>? comments = await commentsStream?.first;

        _postControllerOutput.add(PostLoadedState(
          post: event.post,
          comments: comments,
        ));
      }

      // if (event is PostPost) {
      //   await _postsRepository.createPost();
      //   _postsControllerOutput.add(PostCreateState());
      // }
    } catch (e) {
      _postControllerOutput.add(PostsFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
