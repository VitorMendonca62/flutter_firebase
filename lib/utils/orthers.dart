import 'package:flutter/material.dart';

goTo(String route, BuildContext context, [Object? arguments]) {
  Navigator.of(context).pushNamed(route, arguments: arguments);
}
