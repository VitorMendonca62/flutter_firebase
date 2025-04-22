
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class CardComment extends StatelessWidget {
  final String authorPhoto;
  final String author;
  final DateTime createdAt;
  final String content;

  const CardComment({
    super.key,
    required this.authorPhoto,
    required this.author,
    required this.createdAt,
    required this.content,
  });

  String getRelativeTime(DateTime date) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(date, locale: 'pt_BR');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: NetworkImage(
                  authorPhoto,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CapybaColors.white,
                border: Border.all(
                  color: CapybaColors.capybaGreen,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text(
                          author,
                          maxLines: 2,
                          style: TextStyle(
                            color: CapybaColors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getRelativeTime(createdAt),
                        style: TextStyle(
                          color: CapybaColors.gray2,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.trimRight(),
                    style: TextStyle(
                      color: CapybaColors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
