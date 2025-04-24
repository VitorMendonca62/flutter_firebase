import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/screens/post/pages/create_post_page.dart';
import 'package:flutter_firebase/screens/home/pages/subpages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: SizedBox(
            width: 150,
            child: Text(
                "LOGO AQUI"), /* Image.asset(
              "assets/images/logo_capyba.png",
            ), */
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: CapybaColors.greenGradient,
              border: const Border(
                bottom: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.green,
                width: 1.0,
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: Colors.green.shade500,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              NavigationDestination(
                label: "Criar",
                icon: FaIcon(FontAwesomeIcons.plus),
                selectedIcon: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: [
              const HomePage(),
              const CreatePostPage()
            ][currentPageIndex]),
      ),
    );
  }
}
