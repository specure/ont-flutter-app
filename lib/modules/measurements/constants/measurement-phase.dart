enum MeasurementPhase {
  none,
  fetchingTestParams,
  wait,
  init,
  latency,
  down,
  initUp,
  up,
  jitter,
  packLoss,
  submittingTestResult,
  initLatency
}

extension MeasurementPhaseExt on MeasurementPhase {
  String get name {
    switch (this) {
      case MeasurementPhase.fetchingTestParams:
      case MeasurementPhase.init:
        return 'Initializing download';
      case MeasurementPhase.wait:
        return 'Waiting';
      case MeasurementPhase.initLatency:
        return 'Initializing';
      case MeasurementPhase.latency:
        return 'Ping';
      case MeasurementPhase.down:
        return 'Download';
      case MeasurementPhase.initUp:
        return 'Initializing upload';
      case MeasurementPhase.up:
        return 'Upload';
      case MeasurementPhase.jitter:
        return 'Jitter';
      case MeasurementPhase.packLoss:
        return 'Packet loss';
      case MeasurementPhase.submittingTestResult:
        return 'Submitting test result';
      case MeasurementPhase.none:
      default:
        return '';
    }
  }

  double get progress {
    switch (this) {
      case MeasurementPhase.initLatency:
        return 0.02;
      case MeasurementPhase.latency:
      case MeasurementPhase.jitter:
      case MeasurementPhase.packLoss:
        return 0.2;
      case MeasurementPhase.fetchingTestParams:
        return 0.22;
      case MeasurementPhase.wait:
        return 0.29;
      case MeasurementPhase.init:
        return 0.3;
      case MeasurementPhase.down:
        return 0.6;
      case MeasurementPhase.initUp:
        return 0.7;
      case MeasurementPhase.up:
        return 1;
      case MeasurementPhase.submittingTestResult:
        return 1;
      case MeasurementPhase.none:
      default:
        return 0;
    }
  }

  String get progressUnits {
    switch (this) {
      case MeasurementPhase.down:
      case MeasurementPhase.up:
        return 'Mbps';
      case MeasurementPhase.latency:
      case MeasurementPhase.jitter:
      case MeasurementPhase.packLoss:
        return '%';
      default:
        return '';
    }
  }

  String get resultUnits {
    switch (this) {
      case MeasurementPhase.down:
      case MeasurementPhase.up:
        return 'Mbps';
      case MeasurementPhase.latency:
      case MeasurementPhase.jitter:
        return 'ms';
      case MeasurementPhase.packLoss:
        return '%';
      default:
        return '';
    }
  }
}
