import 'package:flutter/material.dart';

goTo(String route, BuildContext context) {
  Navigator.of(context).pushNamed(route);
}
