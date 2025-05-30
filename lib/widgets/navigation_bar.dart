import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CapybaBottomNavigationBar extends StatefulWidget {
  final int currentPageIndex;
  const CapybaBottomNavigationBar({super.key, required this.currentPageIndex});

  @override
  State<CapybaBottomNavigationBar> createState() =>
      _CapybaBottomNavigationBarState();
}

class _CapybaBottomNavigationBarState extends State<CapybaBottomNavigationBar> {
  late int currentPageIndex;

  @override
  void initState() {
    currentPageIndex = widget.currentPageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: CapybaColors.white,
      indicatorColor: CapybaColors.capybaGreen,
      onDestinationSelected: (int index) {
        if (currentPageIndex != index) {
          switch (index) {
            case 0:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                pushRoute(PathRouter.home, context);
              });
              break;
            case 1:
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  pushRoute(PathRouter.restrict, context);
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SnackBarNotification.error(
                    "Você precisa validar seu email para ter permissão para acessar esssa área",
                    context,
                  );
                });
              }
              break;
          }
        }
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
          label: "Restrito",
          icon: FaIcon(
            FontAwesomeIcons.lock,
            size: 20,
          ),
          selectedIcon: FaIcon(
            FontAwesomeIcons.lock,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}
