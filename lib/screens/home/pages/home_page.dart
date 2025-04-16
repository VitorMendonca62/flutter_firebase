import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/blocs/posts/posts_bloc.dart';
import 'package:flutter_firebase/screens/home/widgets/post.dart';
import 'package:flutter_firebase/screens/widgets/snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Column(
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
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
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
                  child: Text("Erro ao carregarw postagens"),
                ),
              );
            }

            print(state.data?.posts);

            return Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: 5,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 16,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return const Post();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
