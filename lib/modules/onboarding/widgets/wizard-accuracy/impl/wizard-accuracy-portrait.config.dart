import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/wizard-accuracy.config.dart';

class WizardAccuracyPortraitConfig implements WizardAccuracyConfig {
  @override
  EdgeInsets getContainerPadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return EdgeInsets.fromLTRB(28, 128 - (128 * size.aspectRatio), 28, 28);
  }
}
