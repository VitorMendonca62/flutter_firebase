import 'package:timeago/timeago.dart' as timeago;

String getRelativeTime(DateTime date) {
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  return timeago.format(date, locale: 'pt_BR');
}

String formatAuthorName(String author) {
  List<String> authorSplited = author.split(" ");
  String firstName = authorSplited.first;
  String lastName = authorSplited.last;

  return "$firstName $lastName";
}
