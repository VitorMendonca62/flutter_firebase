import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/widgets/post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        SizedBox(
          height: 20,
        ),
        Expanded(
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
        ),
      ],
    );
  }
}
