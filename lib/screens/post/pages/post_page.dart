import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/post/post_model.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/post/blocs/post/post_bloc.dart';
import 'package:flutter_firebase/screens/post/widgets/card_comment.dart';
import 'package:flutter_firebase/screens/post/widgets/comments_input.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/utils/post.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class PostPage extends StatefulWidget {
  final PostModel post;
  final bool isRestrict;

  const PostPage({
    super.key,
    required this.post,
    required this.isRestrict,
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
      isRestrict: widget.isRestrict,
    ));
    super.initState();
  }

  int calcTimeForRead() {
    const int wordsPerMinute = 200;
    final List<String> words = widget.post.content.split(' ');

    return (words.length / wordsPerMinute).ceil();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir esta postagem?'),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: CapybaColors.gray2),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Excluir',
                style: TextStyle(
                  color: CapybaColors.red,
                ),
              ),
              onPressed: () {
                _postBloc.postInput.add(DeletePost(
                  postId: widget.post.id!,
                  isRestrict: widget.isRestrict,
                ));
                Navigator.of(context).pop();
                pushRoute(
                    widget.isRestrict ? PathRouter.restrict : PathRouter.home,
                    context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthor =
        widget.post.authorId == FirebaseAuth.instance.currentUser!.uid;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          canBack: true,
          onBack: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pushRoute(
                widget.isRestrict ? PathRouter.restrict : PathRouter.home,
                context,
              );
            });
          },
          constainsTitleLikeString: true,
          titleLikeString: widget.isRestrict ? "RESTRITO" : "POSTAGEM",
          actions: isAuthor
              ? [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        pushRoute(
                          PathRouter.editPost,
                          context,
                          {
                            'post': widget.post,
                            'isRestrict': widget.isRestrict,
                          },
                        );
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: CapybaColors.red,
                    ),
                    onPressed: _showDeleteDialog,
                  ),
                ]
              : null,
        ),
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
                      formatAuthorName(widget.post.author),
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
                const SizedBox(height: 12),
                Text(
                  widget.post.content,
                  style: TextStyle(
                    color: CapybaColors.black,
                    fontSize: 18,
                  ),
                ),
                if (widget.post.photos.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 24),
                      SizedBox(
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
                                showImageModal(
                                  context,
                                  index,
                                  widget.post.photos,
                                  "network,",
                                );
                              },
                              child: attachedImage(
                                widget.post.photos[index],
                                "network",
                                context,
                                MediaQuery.of(context).size.width * 0.7,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
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
                                          comments: state.data!.comments,
                                          isRestrict: widget.isRestrict,
                                        ),
                                      );
                                      widget.post.liked = true;
                                      widget.post.likes += 1;
                                    } else {
                                      _postBloc.postInput.add(
                                        UnLikePost(
                                          postId: widget.post.id!,
                                          post: widget.post,
                                          comments: state.data!.comments,
                                          isRestrict: widget.isRestrict,
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
                                        if (!_commentsFormKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        _postBloc.postInput.add(CommentPost(
                                          postId: widget.post.id!,
                                          content: commentsInputController.text,
                                          post: widget.post,
                                          comments: state.data!.comments,
                                          index: ammountUserComments,
                                          isRestrict: widget.isRestrict,
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
