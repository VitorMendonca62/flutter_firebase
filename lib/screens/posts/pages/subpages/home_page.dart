import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/posts/blocs/posts/posts_bloc.dart';
import 'package:flutter_firebase/screens/posts/pages/container_page.dart';
import 'package:flutter_firebase/screens/posts/widgets/post.dart';
import 'package:flutter_firebase/screens/posts/widgets/post_nothing_data.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostsBloc _postsBloc;

  @override
  void initState() {
    _postsBloc = PostsBloc();
    _postsBloc.postsInput.add(const GetPosts());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  handleLoading(PostsState data, BuildContext context) {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: 4,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
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

  handleError(PostsFailureState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        data.exception,
        context,
      );
    });
    data.wasHandled = true;

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text("Erro ao carregar postagens"),
      ),
    );
  }

  handleLogout(LogoutState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goTo(PathRouter.login, context);
    });
    data.wasHandled = true;

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text("Erro ao carregar postagens"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerPage(
      handleLogout: () {
        _postsBloc.postsInput.add(const LogoutEvent());
      },
      currentPageIndex: 0,
      child: RefreshIndicator(
        onRefresh: () async {
          _postsBloc.postsInput.add(const GetPosts());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Postagens",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: CapybaColors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<PostsState>(
              stream: _postsBloc.postsOutput,
              initialData: PostsInitialState(),
              builder: (context, state) {
                final PostsState data = state.data!;

                if (data is LogoutState) {
                  return handleLogout(data, context);
                }

                if (data is PostsLoadingState) {
                  return handleLoading(data, context);
                }

                if (data is PostsFailureState && !data.wasHandled) {
                  return handleError(data, context);
                }

                return Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: data.posts.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (BuildContext context, int index) {
                      final post = data.posts[index];
                      return Post(
                        post: post,
                        postBloc: _postsBloc,
                        posts: data.posts,
                        isRestrict: false,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
