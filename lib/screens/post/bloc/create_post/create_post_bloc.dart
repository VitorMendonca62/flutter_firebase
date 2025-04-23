import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';
import 'package:flutter_firebase/screens/post/repositories/post_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc {
  final photoRepository = PhotoRepository();
  final postRepository = PostRepository();

  final StreamController<CreatePostEvent> _createPostControllerInput =
      StreamController<CreatePostEvent>();
  final StreamController<CreatePostState> _createPostControllerOutput =
      StreamController<CreatePostState>();

  Sink<CreatePostEvent> get createPostInput => _createPostControllerInput.sink;
  Stream<CreatePostState> get createPostOutput =>
      _createPostControllerOutput.stream;

  CreatePostBloc() {
    _createPostControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CreatePostEvent event) async {
    late File? photo;
    _createPostControllerOutput.add(CreatePostLoadingState());
    try {
      if (event is AddPhoto) {
        photo = event.photo;
        event.photos.add(photo);
        _createPostControllerOutput.add(CreatePostLoadedState(
          photo: photo,
          photos: event.photos,
        ));
      }

      if (event is RemovePhoto) {
        photo = event.photo;
        event.photos.remove(photo);
        _createPostControllerOutput.add(CreatePostLoadedState(
          photo: photo,
          photos: event.photos,
        ));
      }

      if (event is CreatePostRequested) {
        final List<String> photosLinks = [];
        for (var photo in event.photos) {
          try {
            final link = await photoRepository.uploadPhotoInImgur(photo);
            photosLinks.add(link);
            // ignore: empty_catches
          } catch (e) {}
        }

        final Timestamp timeNow = Timestamp.now();

        await postRepository.createPost(
          event.title,
          event.content,
          photosLinks,
          timeNow,
        );
        _createPostControllerOutput.add(
          CreatePostSubmitedState(
            photos: event.photos,
          ),
        );
      }
    } catch (e) {
      photo = null;
      _createPostControllerOutput.add(CreatePostFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
