import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/wizard-accuracy.config.dart';

class WizardAccuracyLandscapeConfig implements WizardAccuracyConfig {
  @override
  EdgeInsets getContainerPadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return EdgeInsets.fromLTRB(28, 84 - (84 / size.aspectRatio), 28, 28);
  }
}
