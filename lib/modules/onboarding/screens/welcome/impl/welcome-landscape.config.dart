import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/welcome.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-button.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-image.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-message.widget.dart';

class WelcomeLandscapeConfig implements WelcomeConfig {
  @override
  Widget getContent(BuildContext context) {
    final height = (MediaQuery.of(context).size.height / 3) + 32;
    return Padding(
      padding: EdgeInsets.only(top: 92),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height,
            width: height,
            child: WelcomeImage(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: WelcomeMessage(
                    title: "Welcome to #appName"
                        .translated
                        .replaceAll('#appName', Environment.appName),
                    lead: "Let's Review your Privacy Options",
                  ),
                ),
                WelcomeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
