import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class HeaderWithLogo extends StatelessWidget {
  static final logoKey = UniqueKey();

  HeaderWithLogo({
    Key? key,
    this.additionalButtons,
  }) : super(key: key);

  final List<Widget>? additionalButtons;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: size.width * 0.36,
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(maxHeight: 50),
                  child: Image(
                    key: logoKey,
                    image: AssetImage(
                        'config/${Environment.appSuffix}/images/logo.png'),
                  ),
                )),
            ...(additionalButtons != null ? additionalButtons! : [])
          ],
        ));
  }
}
