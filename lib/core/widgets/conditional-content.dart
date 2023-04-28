import 'package:flutter/material.dart';

class ConditionalContent extends StatelessWidget {
  final bool conditional;
  final Widget Function()? falsyBuilder;
  final Widget Function() truthyBuilder;

  ConditionalContent({
    required this.conditional,
    required this.truthyBuilder,
    this.falsyBuilder,
  });

  @override
  Widget build(BuildContext context) => conditional
      ? truthyBuilder()
      : falsyBuilder != null
          ? falsyBuilder!()
          : Container();
}
