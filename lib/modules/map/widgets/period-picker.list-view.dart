import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class PeriodPickerListView extends StatefulWidget {
  final List<String> items;
  final double itemHeight;
  final Alignment align;
  final int initialItemIndex;
  final Function(int)? onItemIndexChange;

  PeriodPickerListView({
    required this.items,
    this.itemHeight = 40,
    this.align = Alignment.center,
    this.initialItemIndex = 0,
    this.onItemIndexChange,
  });

  @override
  State<StatefulWidget> createState() {
    return _PeriodPickerListViewState();
  }
}

class _PeriodPickerListViewState extends State<PeriodPickerListView> {
  late ScrollController controller;
  int currentItemIndex = 0;
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    currentItemIndex = widget.initialItemIndex;
    controller = ScrollController(
      initialScrollOffset: currentItemIndex * widget.itemHeight,
    );
    controller.addListener(_controllerListener);
  }

  @override
  void didUpdateWidget(PeriodPickerListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentItemIndex = widget.initialItemIndex;
    controller.jumpTo(currentItemIndex * widget.itemHeight);
  }

  void _controllerListener() {
    var index = (controller.offset / widget.itemHeight).round();
    if (index != currentItemIndex) {
      if ((_scrollDebounce?.isActive) ?? false) {
        _scrollDebounce?.cancel();
      }
      _scrollDebounce = Timer(Duration(milliseconds: 400), () {
        controller.animateTo(
          index * widget.itemHeight,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        widget.onItemIndexChange?.call(index);
      });
      setState(() => currentItemIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsetsDirectional.only(bottom: 80),
      controller: controller,
      itemCount: widget.items.length,
      itemBuilder: (context, index) => Container(
        height: widget.itemHeight,
        alignment: widget.align,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Text(
          widget.items[index].translated,
          style: TextStyle(
            color:
                index == currentItemIndex ? NTColors.primary : Colors.black45,
          ),
        ),
      ),
    );
  }
}
