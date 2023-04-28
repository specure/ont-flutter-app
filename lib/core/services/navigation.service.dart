import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushRoute(String routeName, dynamic arguments) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementRoute(String routeName, dynamic arguments) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? pushScreen(Widget screen) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .push(MaterialPageRoute(builder: (context) => screen));
    }
    return null;
  }

  Future<dynamic>? pushNamed(String routeName, {dynamic arguments}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
    return null;
  }

  Future<dynamic>? pushNamedAndCleanRoutes(String routeName,
      {dynamic arguments}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(
          routeName, (r) => false,
          arguments: arguments);
    }
    return null;
  }

  goBack({int levels = 1}) {
    for (var i = 0; i < levels; i++) {
      if (navigatorKey.currentState != null &&
          navigatorKey.currentState!.canPop()) {
        navigatorKey.currentState?.pop();
      }
    }
  }

  showBottomSheet(
    Widget child, {
    Color? backgroundColor,
    Color? barrierColor,
    bool? dismissible,
  }) {
    showModalBottomSheet(
      context: navigatorKey.currentState!.context,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor ?? Colors.transparent,
      isDismissible: dismissible ?? true,
      builder: (context) => child,
    );
  }
}
