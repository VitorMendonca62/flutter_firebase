import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool constainsTitleLikeString;
  final String titleLikeString;
  final bool canBack;
  final List<Widget>? actions;
  final void Function()? onBack;

  @override
  const CustomAppBar({
    super.key,
    required this.constainsTitleLikeString,
    required this.titleLikeString,
    this.onBack,
    required this.canBack,
    this.actions,
  });

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
      actions: actions,
      iconTheme: IconThemeData(
        size: 28,
        color: CapybaColors.black,
      ),
      leading: canBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: CapybaColors.white,
              ),
              onPressed: onBack,
            )
          : null,
      centerTitle: true,
      title: constainsTitleLikeString
          ? Text(
              titleLikeString,
              style: TextStyle(
                color: CapybaColors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : SizedBox(
              width: 150,
              child: Image.asset(
                "assets/images/logo_capyba.png",
              ),
            ),
    );
  }
}
