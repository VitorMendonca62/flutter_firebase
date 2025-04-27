import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/screens/post/blocs/edit_post/edit_post_bloc.dart';
import 'package:flutter_firebase/utils/photo.dart';

class PostImages extends StatelessWidget {
  final EditPostState data;
  final List<dynamic>? newPhotos;
  final List<dynamic> oldPhotos;
  final void Function(EditPostState data, int index, bool isNewPhoto)
      handleDelete;

  const PostImages({
    super.key,
    required this.handleDelete,
    required this.data,
    required this.newPhotos,
    required this.oldPhotos,
  });

  @override
  Widget build(BuildContext context) {
    int newPhotosLength = newPhotos == null ? 0 : newPhotos!.length;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: oldPhotos.length + newPhotosLength,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          width: 16,
        ),
        itemBuilder: (context, index) {
          List<dynamic> photos = [...oldPhotos, ...(newPhotos ?? [])];
          String type = index >= oldPhotos.length ? "file" : "network";
          return GestureDetector(
            onTap: () {
              showImageModal(context, index, photos, type);
            },
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 100,
                    child: attachedImage(
                      photos[index],
                      type,
                      context,
                      MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: GestureDetector(
                      onTap: () =>
                          handleDelete(data, index, index >= oldPhotos.length),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CapybaColors.capybaGreen,
                        ),
                        child: Icon(
                          Icons.delete,
                          color: CapybaColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
