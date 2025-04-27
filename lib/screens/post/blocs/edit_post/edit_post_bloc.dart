import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';
import 'package:flutter_firebase/screens/post/repositories/post_repository.dart';

part 'edit_post_event.dart';
part 'edit_post_state.dart';

class EditPostBloc {
  final photoRepository = PhotoRepository();
  final postRepository = PostRepository();

  final StreamController<EditPostEvent> _editPostControllerInput =
      StreamController<EditPostEvent>();
  final StreamController<EditPostState> _editPostControllerOutput =
      StreamController<EditPostState>();

  Sink<EditPostEvent> get editPostInput => _editPostControllerInput.sink;
  Stream<EditPostState> get editPostOutput => _editPostControllerOutput.stream;

  EditPostBloc() {
    _editPostControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(EditPostEvent event) async {
    _editPostControllerOutput.add(EditPostLoadingState(
      photos: event.photos,
      newPhotos: event.newPhotos,
      isRestrict: event.isRestrict,
    ));
    try {

      if (event is AddPhoto) {
        File photo = event.photo;
        event.newPhotos ??= [];
        event.newPhotos!.add(photo);

        _editPostControllerOutput.add(EditPostLoadedState(
          isRestrict: event.isRestrict,
          photos: event.photos,
          newPhotos: event.newPhotos,
        ));
      }

      if (event is RemovePhoto) {
        int index = event.index;
        if (event.newPhotos != null && event.isNewPhoto) {
          if (event.newPhotos!.length == 1) {
            event.newPhotos = null;
          } else {
            event.newPhotos!.removeAt(index);
          }
        } else {
          event.photos.removeAt(index);
        }

        _editPostControllerOutput.add(EditPostLoadedState(
          isRestrict: event.isRestrict,
          photos: event.photos,
          newPhotos: event.newPhotos,
        ));
      }

      if (event is EditPostRequested) {
        final List<String> photosLinks = [];
        if (event.newPhotos != null) {
          for (var photo in event.newPhotos!) {
            try {
              final link = await photoRepository.uploadPhotoInImgur(photo);
              photosLinks.add(link);
              // ignore: empty_catches
            } catch (e) {}
          }
        }

        final Timestamp timeNow = Timestamp.now();

        await postRepository.editPost(
          event.postId,
          event.title,
          event.content,
          event.photos,
          photosLinks,
          timeNow,
          event.isRestrict,
        );
        _editPostControllerOutput.add(
          EditPostSubmitedState(
            isRestrict: event.isRestrict,
            photos: event.photos,
            newPhotos: event.newPhotos,
          ),
        );
      }
    } catch (e) {
      _editPostControllerOutput.add(EditPostFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
        isRestrict: event.isRestrict,
        photos: event.photos,
        newPhotos: event.newPhotos,
      ));
    }
  }
}
