import 'package:flutter_firebase/models/post/post_model.dart';
// ignore: unused_import
import 'package:flutter_firebase/screens/galery_page.dart';
import 'package:flutter_firebase/screens/home/blocs/posts/posts_bloc.dart';
import 'package:flutter_firebase/screens/post/pages/post_page.dart';
import 'package:flutter_firebase/utils/photo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/utils/post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Post extends StatelessWidget {
  final PostModel post;
  final List<PostModel> posts;
  final PostsBloc postBloc;
  final bool isRestrict;

  const Post({
    super.key,
    required this.post,
    required this.posts,
    required this.postBloc,
    required this.isRestrict,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CapybaColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: CapybaColors.capybaGreen,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostPage(
                post: post,
                isRestrict: isRestrict ,
              ),
            ),
          );
        },
        splashColor: CapybaColors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
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
                          image: NetworkImage(
                            post.authorPhoto.split(',').last,
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
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
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
                style: TextStyle(
                  color: CapybaColors.black,
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
                                children: post.photos
                                    .sublist(0, 2)
                                    .asMap()
                                    .entries
                                    .map(
                                  (entry) {
                                    final index = entry.key;
                                    final photo = entry.value;
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => showImageModal(
                                            context,
                                            index,
                                            post.photos,
                                          ),
                                          child: attachedImage(photo, context),
                                        ),
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
                                  GestureDetector(
                                    onTap: () => showImageModal(
                                      context,
                                      0,
                                      post.photos,
                                    ),
                                    child: attachedImage(
                                        post.photos.first, context),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                        post.photos.length > 2
                            ? GestureDetector(
                                onTap: () => showImageModal(
                                  context,
                                  2,
                                  post.photos,
                                ),
                                child: Stack(
                                  children: [
                                    attachedImage(post.photos[2], context),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 50,
                                      color:
                                          CapybaColors.black.withOpacity(0.4),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                ),
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
                  SizedBox(
                    width: 50,
                    height: 40,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      hoverColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
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
                                : CapybaColors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              post.likes.toString(),
                              style: TextStyle(
                                color: CapybaColors.black,
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
                      FaIcon(
                        FontAwesomeIcons.message,
                        size: 22,
                        color: CapybaColors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          post.comments.toString(),
                          style: TextStyle(
                            color: CapybaColors.black,
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
      ),
    );
  }
}
