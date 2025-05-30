import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
import 'package:flutter_firebase/widgets/drawer_widget.dart';
import 'package:flutter_firebase/widgets/navigation_bar.dart';

class ContainerPage extends StatefulWidget {
  final Widget child;
  final int currentPageIndex;
  final VoidCallback handleLogout;

  const ContainerPage({
    super.key,
    required this.child,
    required this.currentPageIndex,
    required this.handleLogout,
  });

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentPageIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          canBack: false,
          constainsTitleLikeString: false,
          titleLikeString: "",
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CapybaColors.capybaDarkGreen,
                width: 1.0,
              ),
            ),
          ),
          child: CapybaBottomNavigationBar(
            currentPageIndex: currentPageIndex,
          ),
        ),
        drawer: DrawerWidget(handleLogout: widget.handleLogout),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          child: Stack(
            children: [
              widget.child,
              Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      pushRoute(PathRouter.createPost, context);
                    });
                  },
                  backgroundColor: CapybaColors.capybaGreen,
                  child: Icon(
                    Icons.add,
                    color: CapybaColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
