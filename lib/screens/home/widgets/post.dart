import 'dart:convert';
import 'package:flutter_firebase/models/post/post_model.dart';
import 'package:flutter_firebase/screens/home/blocs/posts/posts_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Post extends StatelessWidget {
  final PostModel post;
  final List<PostModel> posts;
  final PostsBloc postBloc;

  const Post({
    super.key,
    required this.post,
    required this.posts,
    required this.postBloc,
  });

  String getRelativeTime(DateTime date) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  attachedImage(String source, BuildContext context) {
    final base64String = source.split(',').last;
    final decodedBytes = base64Decode(base64String);

    return Image.memory(
      decodedBytes,
      width: MediaQuery.of(context).size.width * 0.2,
      height: 50,
      fit: BoxFit.fill,
    );
  }

  profileImage(String source) {
    final base64String = source.split(',').last;
    final decodedBytes = base64Decode(base64String);

    return Expanded(
      child: Image.memory(
        decodedBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        overlayColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.green,
              width: 1,
            )),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: MemoryImage(
                          base64Decode(post.authorPhoto.split(',').last),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author,
                        style: TextStyle(
                          color: CapybaColors.black,
                        ),
                      ),
                      Text(
                        getRelativeTime(post.createdAt),
                        style: TextStyle(
                          color: CapybaColors.gray2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              post.title,
              style: TextStyle(
                color: CapybaColors.capybaDarkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              post.content,
              maxLines: 5,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            post.photos.isNotEmpty
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      post.photos.length >= 2
                          ? Row(
                              children: post.photos.sublist(0, 2).map(
                                (photo) {
                                  return Row(
                                    children: [
                                      attachedImage(photo, context),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            )
                          : Row(
                              children: [
                                attachedImage(post.photos.first, context),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                      post.photos.length > 2
                          ? Stack(
                              children: [
                                attachedImage(post.photos[1], context),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 50,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo_library,
                                        color: CapybaColors.white,
                                      ),
                                      Text(
                                        "+${post.photos.length - 2}",
                                        style: TextStyle(
                                          color: CapybaColors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!post.liked) {
                      postBloc.postsInput.add(
                        LikePost(
                          postId: post.id!,
                          posts: posts,
                        ),
                      );
                      post.liked = true;
                      post.likes += 1;
                    } else {
                      postBloc.postsInput.add(
                        UnLikePost(
                          postId: post.id!,
                          posts: posts,
                        ),
                      );
                      post.liked = false;
                      post.likes -= 1;
                    }
                  },
                  child: SizedBox(
                    width: 50,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          post.liked
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          size: 22,
                          color: post.liked
                              ? CapybaColors.capybaGreen
                              : Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            post.likes.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.message,
                      size: 22,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        post.comments.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
