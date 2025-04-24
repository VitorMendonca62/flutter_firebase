import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget child;
  const AuthHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: CapybaColors.greenGradient,
          ),
          child: Image.asset(
            "assets/images/logo_capyba.png",
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: CapybaColors.greenGradient,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: CapybaColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 12,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: CapybaColors.gray1,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: CapybaColors.gray2,
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
