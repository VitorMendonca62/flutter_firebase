import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      backgroundColor: CapybaColors.capybaGreen,
      width: MediaQuery.of(context).size.width * 0.85,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed(
                  Routes.profile,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      user.photoURL!,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        user.displayName!.split(" ").first,
                        style: TextStyle(
                          color: CapybaColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ver perfil',
                        style: TextStyle(
                          color: CapybaColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                InkWell(
                  splashColor: CapybaColors.capybaDarkGreen,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.validateEmail);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mail,
                          color: CapybaColors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Validar e-mail",
                          style: TextStyle(
                            color: CapybaColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  splashColor: CapybaColors.capybaDarkGreen,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.login);
                    FirebaseAuth.instance.signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: CapybaColors.white,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Sair",
                          style: TextStyle(
                            color: CapybaColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
