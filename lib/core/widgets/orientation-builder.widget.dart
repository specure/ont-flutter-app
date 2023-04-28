import 'package:flutter/material.dart';

class NTOrientationBuilder<T> extends StatefulWidget {
  final T portraitConfig;
  final T? landscapeConfig;
  final Widget Function(T config) builder;

  NTOrientationBuilder({
    required this.portraitConfig,
    required this.builder,
    this.landscapeConfig,
  });

  @override
  State<NTOrientationBuilder<T>> createState() =>
      _NTOrientationBuilderState<T>();
}

class _NTOrientationBuilderState<T> extends State<NTOrientationBuilder<T>> {
  T? config;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        widget.landscapeConfig != null) {
      this.config = widget.landscapeConfig!;
    } else {
      this.config = widget.portraitConfig;
    }
    return widget.builder(config!);
  }
}
