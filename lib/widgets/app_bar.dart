import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: CapybaColors.greenInvertGradient,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        size: 28,
        color: CapybaColors.white,
      ),
      centerTitle: true,
      title: SizedBox(
        width: 150,
        child: Image.asset(
          "assets/images/logo_capyba.png",
        ),
      ),
    );
  }
}
