import 'dart:convert';
import 'package:flutter_firebase/models/post/post_model.dart';
import 'package:flutter_firebase/screens/galery_page.dart';
import 'package:flutter_firebase/screens/post/bloc/post/post_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class PostPage extends StatefulWidget {
  final PostModel post;

  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final PostBloc _postBloc;

  @override
  void initState() {
    _postBloc = PostBloc();
    super.initState();
  }

  String getRelativeTime(DateTime date) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  attachedImage(String source, BuildContext context) {
    final base64String = source.split(',').last;
    final decodedBytes = base64Decode(base64String);

    return Image.memory(
      decodedBytes,
      width: MediaQuery.of(context).size.width * 0.7,
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

  int calcTimeForRead() {
    const int wordsPerMinute = 200;
    final List<String> words = widget.post.content.split(' ');

    return (words.length / wordsPerMinute).ceil();
  }

  void showImageModal(BuildContext context, int initialValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            body: Center(
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GalleryPage(
                      initialIndex: initialValue,
                      images: widget.post.photos.map((base64) {
                        final bytes = base64Decode(base64.split(',').last);
                        return MemoryImage(bytes);
                      }).toList(),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.title,
                  style: TextStyle(
                    color: CapybaColors.capybaDarkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.post.author,
                      style: TextStyle(
                        color: CapybaColors.gray2,
                        fontSize: 12,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("·"),
                    ),
                    Text(
                      getRelativeTime(widget.post.createdAt),
                      style: TextStyle(
                        color: CapybaColors.gray2,
                        fontSize: 12,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("·"),
                    ),
                    Text(
                      "${calcTimeForRead()} min de leitura",
                      style: TextStyle(
                        color: CapybaColors.gray2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  widget.post.content,
                  style: TextStyle(
                    color: CapybaColors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 200,
                  child: Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: 16,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showImageModal(context, index);
                          },
                          child: attachedImage(
                            widget.post.photos[0],
                            context,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                StreamBuilder<PostState>(
                    stream: _postBloc.postOutput,
                    initialData: PostInitialState(post: widget.post),
                    builder: (context, state) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 40,
                                child: InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  hoverColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    if (!widget.post.liked) {
                                      _postBloc.postInput.add(
                                        LikePost(
                                          postId: widget.post.id!,
                                          post: widget.post,
                                        ),
                                      );
                                      widget.post.liked = true;
                                      widget.post.likes += 1;
                                    } else {
                                      _postBloc.postInput.add(
                                        UnLikePost(
                                          postId: widget.post.id!,
                                          post: widget.post,
                                        ),
                                      );
                                      widget.post.liked = false;
                                      widget.post.likes -= 1;
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.post.liked
                                            ? Icons.thumb_up_alt
                                            : Icons.thumb_up_alt_outlined,
                                        size: 22,
                                        color: widget.post.liked
                                            ? CapybaColors.capybaGreen
                                            : Colors.black,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          widget.post.likes.toString(),
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
                                      widget.post.comments.toString(),
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
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
