import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';

class WelcomeImage extends StatelessWidget {
  static final imageKey = UniqueKey();

  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'config/${Environment.appSuffix}/images/splash-screen-hero.svg',
        key: imageKey,
      ),
    );
  }
}
