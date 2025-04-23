import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/post/post_model.dart';
import 'package:flutter_firebase/screens/galery_page.dart';
import 'package:flutter_firebase/screens/post/bloc/post/post_bloc.dart';
import 'package:flutter_firebase/screens/post/widgets/card_comment.dart';
import 'package:flutter_firebase/screens/post/widgets/comments_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final User user = FirebaseAuth.instance.currentUser!;

  int ammountUserComments = 0;

  final TextEditingController commentsInputController = TextEditingController();

  final _commentsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _postBloc = PostBloc();
    _postBloc.postInput.add(GetComments(
      post: widget.post,
      postId: widget.post.id!,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _postBloc.postOutput.drain();
    super.dispose();
  }

  String getRelativeTime(DateTime date) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  attachedImage(String source, BuildContext context) {
    return Image.network(
      source,
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      fit: BoxFit.fill,
    );
  }

  int calcTimeForRead() {
    const int wordsPerMinute = 200;
    final List<String> words = widget.post.content.split(' ');

    return (words.length / wordsPerMinute).ceil();
  }

  showImageModal(BuildContext context, int initialValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: CapybaColors.black.withOpacity(0.1),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: CapybaColors.black.withOpacity(0.8),
            body: Center(
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GalleryPage(
                      initialIndex: initialValue,
                      images: widget.post.photos.map((link) {
                        return NetworkImage(link);
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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                Visibility(
                  visible: widget.post.photos.isNotEmpty,
                  child: SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.post.photos.length,
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
                            widget.post.photos[index],
                            context,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
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
                                            comments: state.data!.comments),
                                      );
                                      widget.post.liked = true;
                                      widget.post.likes += 1;
                                    } else {
                                      _postBloc.postInput.add(
                                        UnLikePost(
                                            postId: widget.post.id!,
                                            post: widget.post,
                                            comments: state.data!.comments),
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
                                            : CapybaColors.black,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Text(
                                          widget.post.likes.toString(),
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
                                width: 16,
                              ),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.message,
                                    size: 22,
                                    color: CapybaColors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Text(
                                      widget.post.comments.toString(),
                                      style: TextStyle(
                                        color: CapybaColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 24),
                                child: Text(
                                  "Comentários",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Form(
                                key: _commentsFormKey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            FirebaseAuth.instance.currentUser!
                                                .photoURL!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: CommentsInput(
                                        controller: commentsInputController,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        _postBloc.postInput.add(CommentPost(
                                          postId: widget.post.id!,
                                          content: commentsInputController.text,
                                          post: widget.post,
                                          comments: state.data!.comments,
                                          index: ammountUserComments,
                                        ));
                                        commentsInputController.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 19,
                                        ),
                                        backgroundColor:
                                            CapybaColors.capybaGreen,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          side: BorderSide(
                                            width: 0.001,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: CapybaColors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: state.data!.comments!.map((comment) {
                                  if (comment.author ==
                                      FirebaseAuth
                                          .instance.currentUser!.displayName) {
                                    ammountUserComments += 1;
                                  }
                                  return Column(
                                    children: [
                                      CardComment(
                                        authorPhoto: comment.authorPhoto,
                                        author: comment.author,
                                        content: comment.content,
                                        createdAt: comment.createdAt,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          )
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
