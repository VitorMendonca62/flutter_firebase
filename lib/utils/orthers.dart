import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

pushRoute(String route, BuildContext context, [Object? arguments]) {
  context.push(route, extra: arguments);
}

goTo(String route, BuildContext context, [Object? arguments]) {
  context.go(route, extra: arguments);
}
