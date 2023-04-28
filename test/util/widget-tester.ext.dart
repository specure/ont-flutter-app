import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpWidgetWithArguments(
    Widget widget, {
    required Object arguments,
  }) async {
    final key = GlobalKey<NavigatorState>();
    await this.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: TextButton(
          onPressed: () => key.currentState?.push(
            MaterialPageRoute<void>(
              settings: RouteSettings(arguments: arguments),
              builder: (_) => widget,
            ),
          ),
          child: const SizedBox(),
        ),
      ),
    );
    await this.tap(find.byType(TextButton));
  }
}
