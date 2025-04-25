import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/home/blocs/posts/posts_bloc.dart';
import 'package:flutter_firebase/screens/home/widgets/post.dart';
import 'package:flutter_firebase/screens/home/widgets/post_nothing_data.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

class RestrictPage extends StatefulWidget {
  const RestrictPage({
    super.key,
  });

  @override
  State<RestrictPage> createState() => _RestrictPageState();
}

class _RestrictPageState extends State<RestrictPage> {
  late final PostsBloc _postsBloc;

  @override
  void initState() {
    _postsBloc = PostsBloc();
    _postsBloc.postsInput.add(const GetPosts(isRestrict: true));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _postsBloc.postsInput.add(const GetPosts(isRestrict: true));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Restritos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<PostsState>(
            stream: _postsBloc.postsOutput,
            initialData: PostsInitialState(),
            builder: (context, state) {
              if (state.data is PostsLoadingState) {
                return Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: 4,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 16,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: const PostNothingData(),
                      );
                    },
                  ),
                );
              }

              if (state.data is PostsFailureState && !state.data!.wasHandled) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  SnackBarNotification.error(
                    (state.data as PostsFailureState).exception,
                    context,
                  );
                  if ((state.data as PostsFailureState).exception ==
                      "Você precisa validar seu email para ter permissão") {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  }
                });
                state.data!.wasHandled = true;
                return const SizedBox();
              }

              return Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: state.data!.posts.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final post = state.data!.posts[index];
                    return Post(
                      post: post,
                      postBloc: _postsBloc,
                      posts: state.data!.posts,
                      isRestrict: true,
                    );
                  },
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Siar'),
          )
        ],
      ),
    );
  }
}
