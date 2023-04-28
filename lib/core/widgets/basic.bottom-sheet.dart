import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class BasicBottomSheet extends StatelessWidget {
  final double? height;
  final Widget child;
  final bool? includeHeader;
  final String? headerTitle;
  final EdgeInsets? padding;

  BasicBottomSheet({
    this.height,
    required this.child,
    this.includeHeader,
    this.headerTitle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height ?? 300,
        child: ConditionalContent(
          conditional: includeHeader ?? true,
          truthyBuilder: () => Column(
            children: [
              _Header(headerTitle ?? ''),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ],
          ),
          falsyBuilder: () => child,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  _Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.translated.toUpperCase(),
            style: TextStyle(
              fontSize: NTDimensions.textS,
              color: Colors.black54,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
