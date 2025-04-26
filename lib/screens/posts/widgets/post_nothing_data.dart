import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostNothingData extends StatelessWidget {
  const PostNothingData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(0),
        overlayColor: CapybaColors.black.withOpacity(0.2),
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
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "author",
                        style: TextStyle(
                          color: CapybaColors.black,
                        ),
                      ),
                      Text(
                        "dawwadawd awdawd AWD",
                        style: TextStyle(
                          color: CapybaColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              " dawdwa daw daw daw daw dawd aw",
              style: TextStyle(
                color: CapybaColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "dadawd aw dwa aw daw daw daw D aw daw daw dwa awd dawwdawaddwaawdd awadw dw dawa da dwadw a wda wdwdadwadwadw dawd daw dawd awdwaa dwawd a wawd awd a wd dwa awawddawawdawd daw awdawa wa wdadwwadda wad adw a w dawd aw aw awd awa w awd",
              maxLines: 5,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: CapybaColors.black,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 50,
                    color: Colors.red,
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 22,
                        color: CapybaColors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: CapybaColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.message,
                      size: 22,
                      color: CapybaColors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "12",
                        style: TextStyle(
                          color: CapybaColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
