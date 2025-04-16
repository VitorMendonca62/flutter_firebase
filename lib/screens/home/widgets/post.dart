import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  attachedImage(String source) {
    return Image.network(
      source,
      width: 120,
      height: 120,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        overlayColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.green,
              width: 1,
            )),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("vitormendonca "),
                      Text("23/23/24 12:45"),
                    ],
                  ),
                ],
              ),
            ),
            const Text(
              'Titulo',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae ipsum iaculis, rhoncus purus quis, ultrices mi. Donec ornare sodales convallis. Sed at auctor mauris, eget maximus mi. Nulla placerat finibus enim id volutpat. Mauris tellus ligula, blandit vitae finibus ac, accumsan at ex. Sed pretium porta lorem, et mollis quam fringilla vitae. Sed sed dolor diam. Nulla nunc justo, suscipit at velit a, gravida aliquam risus. Donec consectetur nulla quis velit dictum condimentum. Mauris laoreet id erat efficitur elementum. Maecenas quis finibus massa. Cras dui lacus, tincidunt ut quam vitae, semper maximus odio. Aenean consectetur accumsan dui, eget convallis magna dignissim vitae. Aenean tempor, ipsum et consectetur scelerisque, mi mi venenatis diam, in lacinia lacus urna nec lacus. Phasellus sit amet neque eu diam iaculis facilisis.',
              maxLines: 5,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                attachedImage(
                  "https://static.vecteezy.com/ti/vetor-gratis/p1/464019-conjunto-de-ui-ux-telas-de-gui-compras-app-design-plano-modelo-para-aplicativos-moveis-wireframes-site-responsivo-kit-de-interface-do-usuario-de-web-design-painel-de-compras-vetor.jpg",
                ),
                const SizedBox(
                  width: 20,
                ),
                attachedImage(
                  "https://static.vecteezy.com/ti/vetor-gratis/p1/464019-conjunto-de-ui-ux-telas-de-gui-compras-app-design-plano-modelo-para-aplicativos-moveis-wireframes-site-responsivo-kit-de-interface-do-usuario-de-web-design-painel-de-compras-vetor.jpg",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 22,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        ' 1 ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.message,
                          size: 22,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            ' 0',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
