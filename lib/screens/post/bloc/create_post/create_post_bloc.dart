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
    _createPostControllerOutput.add(CreatePostLoadingState(
      photos: event.photos,
      isRestrict: event.isRestrict,
    ));
    try {
      if (event is ChangeSwitch) {
        _createPostControllerOutput.add(CreatePostLoadedState(
          isRestrict: event.isRestrict,
          photos: event.photos,
        ));
      }

      if (event is AddPhoto) {
        File photo = event.photo;
        event.photos.add(photo);
        _createPostControllerOutput.add(CreatePostLoadedState(
          isRestrict: event.isRestrict,
          photos: event.photos,
        ));
      }

      if (event is RemovePhoto) {
        File photo = event.photo;
        event.photos.remove(photo);
        _createPostControllerOutput.add(CreatePostLoadedState(
          isRestrict: event.isRestrict,
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
          event.isRestrict,
        );
        _createPostControllerOutput.add(
          CreatePostSubmitedState(
            isRestrict: event.isRestrict,
            photos: [],
          ),
        );
      }
    } catch (e) {
      _createPostControllerOutput.add(CreatePostFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
        isRestrict: event.isRestrict,
        photos: event.photos,
      ));
    }
  }
}
