import 'package:nt_flutter_standalone/modules/measurement-result/models/loop-mode-settings-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/loop-mode-details.dart';

extension Mapper on LoopModeDetails {
  LoopModeSettings? toLoopModeSettings(bool isActivated) {
    if (!isActivated) {
      return null;
    }
    return LoopModeSettings(
        loopUuid: this.loopUuid,
        targetTestCount: this.targetNumberOfTests,
        targetWaitingTimeSeconds: this.targetTimeSecondsToNextTest,
        targetDistanceMeters: this.targetDistanceMetersToNextTest,
        currentTestNumber: this.currentNumberOfTestsStarted);
  }
}
