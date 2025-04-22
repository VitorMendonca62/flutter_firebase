import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/blocs/posts/posts_bloc.dart';
import 'package:flutter_firebase/screens/home/widgets/post.dart';
import 'package:flutter_firebase/screens/home/widgets/post_nothing_data.dart';
import 'package:flutter_firebase/screens/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostsBloc _postsBloc;

  @override
  void initState() {
    _postsBloc = PostsBloc();
    _postsBloc.postsInput.add(GetPosts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _postsBloc.postsInput.add(GetPosts());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Postagens",
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
                SnackBarNotification.error(
                  (state.data as PostsFailureState).exception,
                  context,
                );
                state.data!.wasHandled = true;
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text("Erro ao carregar postagens"),
                  ),
                );
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
                        posts: state.data!.posts);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
