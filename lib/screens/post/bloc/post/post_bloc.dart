import 'dart:async';

import 'package:flutter_firebase/models/comment/comment_model.dart';

import '../../repositories/post_repository.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PhotoBloc {
  final _postRepository = PostRepository();

  final StreamController<PostEvent> _postControllerInput =
      StreamController<PostEvent>();
  final StreamController<PostState> _postControllerOutput =
      StreamController<PostState>();

  Sink<PostEvent> get postInput => _postControllerInput.sink;
  Stream<PostState> get postOutput => _postControllerOutput.stream;

  PhotoBloc() {
    _postControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PostEvent event) async {
    /*   try { */
    if (!(event is LikePost || event is UnLikePost)) {
      _postControllerOutput.add(PostLoadingState());
    }

    if (event is GetPost) {
      PostModel? post = await _postRepository.getOne(event.postId);
      _postControllerOutput.add(PostLoadedState(
        post: post,
        comments:
            await (await _postRepository.getComments(event.postId))?.first,
      ));
    }

    if (event is LikePost) {
      await _postRepository.changeLikePost(event.postId, event.type);
      _postControllerOutput.add(PostLoadedState(
        post: event.post,
        comments: event.comments,
      ));
    }

    if (event is UnLikePost) {
      await _postRepository.changeLikePost(event.postId, event.type);
      _postControllerOutput
          .add(PostLoadedState(post: event.post, comments: event.comments));
    }

    if (event is CommentPost) {
      final model = await _postRepository.addComment(
        event.postId,
        event.content,
        event.index,
      );
      event.comments?.add(model);
      _postControllerOutput.add(PostLoadedState(
        post: event.post,
        comments: event.comments,
      ));
    }

    if (event is GetComments) {
      Stream<List<CommentModel>?>? commentsStream =
          await _postRepository.getComments(event.postId);
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
    /*  } catch (e) {
      _postsControllerOutput.add(PostFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    } */
  }
}
