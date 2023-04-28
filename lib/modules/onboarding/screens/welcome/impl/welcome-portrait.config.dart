import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/welcome.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-button.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-image.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-message.widget.dart';

class WelcomePortraitConfig implements WelcomeConfig {
  @override
  Widget getContent(_) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(28, 56, 28, 0),
              child: WelcomeMessage(
                title: "Welcome to #appName"
                    .translated
                    .replaceAll('#appName', Environment.appName),
                lead: "Let's Review your Privacy Options",
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: WelcomeImage(),
          ),
          Flexible(
            flex: 1,
            child: WelcomeButton(),
          )
        ],
      );
}
