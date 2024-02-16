import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/measurement.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/carrier-info.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/wrappers/ping.wrapper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/unit-tests/dio-service_test.mocks.dart';
import '../../di/service-locator.dart';
import 'measurement-service_test.mocks.dart';

final _methodChannel = MockMethodChannel();
MeasurementService _measurementService =
    MeasurementService(channel: _methodChannel);
final _bloc = MockMeasurementsBlocCalls();
final _version = '4.0.0';
final _packageInfo = PackageInfo(
    appName: '', packageName: '', version: _version, buildNumber: '');

@GenerateMocks([MethodChannel, PingWrapper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    GetIt.I.registerLazySingleton<MeasurementsBloc>(() => _bloc);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.phoneStatePermissionsGranted))
        .thenReturn(true);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.locationPermissionsGranted))
        .thenReturn(true);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.persistentClientUuidEnabled))
        .thenReturn(true);
    when(GetIt.I.get<CarrierInfoWrapper>().getNativeCarrierName())
        .thenAnswer((realInvocation) async => "Carrier");
    when(GetIt.I.get<PlatformWrapper>().isIOS).thenReturn(true);
    PackageInfo.setMockInitialValues(
      appName: '',
      packageName: '',
      version: _version,
      buildNumber: '',
      buildSignature: '',
    );
  });

  group('Start/Stop measurement test', () {
    test('starts measurement test', () async {
      when(_methodChannel.invokeMethod('startTest', {
        'appVersion': '${_packageInfo.version} (${_packageInfo.buildNumber})',
        'clientUUID': 'clientUUID',
        'flavor': Environment.appSuffix,
        'location': {},
        'selectedMeasurementServerId': 1,
        'loopModeSettings': null,
        'enableAppJitterAndPacketLoss': false,
        'telephonyPermissionGranted': true,
        'locationPermissionGranted': true,
        'uuidPermissionGranted': true,
        'pingsNs': [],
        'testStartNs': 0.0,
        'packetLoss': 0.0,
        'jitterNs': 0.0
      })).thenAnswer((_) async => testStartedMessage);
      expect(
        await _measurementService.startTest(
          Environment.appSuffix,
          clientUUID: 'clientUUID',
          measurementServerId: 1,
        ),
        testStartedMessage,
      );
    });
    test('handles errors when starting test', () async {
      when(_methodChannel.invokeMethod('startTest', {
        'appVersion': '${_packageInfo.version} (${_packageInfo.buildNumber})',
        'clientUUID': 'clientUUID',
        'flavor': Environment.appSuffix,
        'location': {},
        'selectedMeasurementServerId': null,
        'loopModeSettings': null,
        'enableAppJitterAndPacketLoss': false,
        'telephonyPermissionGranted': true,
        'locationPermissionGranted': true,
        'uuidPermissionGranted': true,
        'pingsNs': [],
        'testStartNs': 0.0,
        'packetLoss': 0.0,
        'jitterNs': 0.0
      })).thenAnswer((_) async => throw PlatformException(code: '0'));
      expect(
        await _measurementService.startTest(
          Environment.appSuffix,
          clientUUID: 'clientUUID',
        ),
        null,
      );
    });

    test('stops measurement test', () async {
      when(_methodChannel.invokeMethod('stopTest'))
          .thenAnswer((_) async => testStoppedMessage);
      expect(
        await _measurementService.stopTest(),
        testStoppedMessage,
      );
    });

    test('handles errors when stopping test', () async {
      when(_methodChannel.invokeMethod('stopTest'))
          .thenAnswer((_) async => throw PlatformException(code: '0'));
      expect(
        await _measurementService.stopTest(),
        null,
      );
    });

    test('sets phase to .none if arguments are not a map', () async {
      final call = MethodCall('speedMeasurementDidStartPhase', null);
      _measurementService.platformCallHandler(call);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.none,
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
    });

    test('starts a new phase', () {
      final call = MethodCall('speedMeasurementDidStartPhase',
          {'phase': MeasurementPhase.init.index});
      _measurementService.platformCallHandler(call);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
    });

    test('updates progress for the active phase', () {
      final call1 = MethodCall('speedMeasurementDidStartPhase',
          {'phase': MeasurementPhase.latency.index});
      final call2 = MethodCall('speedMeasurementDidUpdateWith',
          {'phase': MeasurementPhase.latency.index, 'progress': 1.0});
      _measurementService.platformCallHandler(call1);
      _measurementService.platformCallHandler(call2);
      verify(_bloc.add(any)).called(2);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call2.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<SetPhaseResult>(),
      );
    });
    test('does not update progress for an inactive phase', () {
      final call1 = MethodCall('speedMeasurementDidStartPhase',
          {'phase': MeasurementPhase.down.index});
      final call2 = MethodCall('speedMeasurementDidUpdateWith',
          {'phase': MeasurementPhase.latency.index, 'progress': 1.0});
      _measurementService.platformCallHandler(call1);
      _measurementService.platformCallHandler(call2);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call1.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
    });

    test('updates result for the active phase', () {
      final call1 = MethodCall('speedMeasurementDidStartPhase',
          {'phase': MeasurementPhase.down.index});
      final call2 = MethodCall('speedMeasurementDidMeasureSpeed',
          {'phase': MeasurementPhase.down.index, 'result': 1.0});
      _measurementService.platformCallHandler(call1);
      _measurementService.platformCallHandler(call2);
      verify(_bloc.add(any)).called(2);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call2.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<SetPhaseResult>(),
      );
      final call3 = MethodCall('speedMeasurementDidFinishPhase',
          {'phase': MeasurementPhase.down.index, 'result': 1.0});
      _measurementService.platformCallHandler(call3);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call2.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<SetPhaseResult>(),
      );
    });
    test('does not update result for an inactive phase', () {
      final call1 = MethodCall('speedMeasurementDidStartPhase',
          {'phase': MeasurementPhase.up.index});
      final call2 = MethodCall('speedMeasurementDidMeasureSpeed',
          {'phase': MeasurementPhase.down.index, 'result': 1.0});
      _measurementService.platformCallHandler(call1);
      _measurementService.platformCallHandler(call2);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call1.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
      final call3 = MethodCall('speedMeasurementDidFinishPhase',
          {'phase': MeasurementPhase.down.index, 'result': 1.0});
      _measurementService.platformCallHandler(call3);
      verifyNever(_bloc.add(any));
      expect(
        _measurementService.lastPhase,
        MeasurementPhase.values[call1.arguments['phase']],
      );
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
    });

    test('completes measurement', () {
      _measurementService = MeasurementService(channel: _methodChannel);
      final call = MethodCall('measurementComplete');
      _measurementService.platformCallHandler(call);
      verify(_bloc.add(any)).called(1);
      expect(_measurementService.lastPhase, null);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<CompleteMeasurement>(),
      );
    });

    test('submits results', () {
      _measurementService = MeasurementService(channel: _methodChannel);
      final call = MethodCall('measurementResultSubmitted');
      _measurementService.platformCallHandler(call);
      verify(_bloc.add(any)).called(1);
      expect(_measurementService.lastPhase, null);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<OnMeasurementComplete>(),
      );
    });

    test('handles no connection during measurement', () {
      when(_bloc.state).thenReturn(MeasurementsState.init());
      _measurementService = MeasurementService(channel: _methodChannel);
      final call = MethodCall('measurementDidFail');
      _measurementService.platformCallHandler(call);
      verify(_bloc.state).called(1);
      verify(_bloc.add(any)).called(1);
      expect(_measurementService.lastPhase, null);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<SetError>(),
      );
    });
    test('handles errors during measurement', () {
      when(_bloc.state).thenReturn(MeasurementsState.init()
          .copyWith(connectivity: ConnectivityResult.wifi));
      _measurementService = MeasurementService(channel: _methodChannel);
      final call = MethodCall('measurementDidFail');
      _measurementService.platformCallHandler(call);
      verify(_bloc.state).called(1);
      verify(_bloc.add(any)).called(1);
      expect(_measurementService.lastPhase, null);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<SetError>(),
      );
    });

    test('calls post-finish methods', () {
      _measurementService = MeasurementService(channel: _methodChannel);
      final call = MethodCall('measurementPostFinish');
      _measurementService.platformCallHandler(call);
      verify(_bloc.add(any)).called(1);
      expect(_measurementService.lastPhase, null);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<MeasurementPostFinish>(),
      );
    });

    test('starts ping test', () async {
      _measurementService = MeasurementService(channel: _methodChannel);
      final host = 'example.com';
      final project = NTProject(pingDuration: 1, pingInterval: 0.5);
      when(GetIt.I
              .get<PingWrapper>()
              .getIstance(host, count: 7, intervalS: 0.5))
          .thenReturn(null);
      await _measurementService.startPingTest(host: host, project: project);
      verify(_bloc.add(any)).called(1);
      expect(
        _measurementService.lastDispatchedEvent,
        isA<StartMeasurementPhase>(),
      );
    });

    test('handles ping summary event', () async {
      _setUpPingPhase();
      final callback = _measurementService.handlePingEvent(
        count: 0,
        progressCount: 0,
        progressPercent: 0,
        pings: [PingResponse(time: Duration(milliseconds: 0))],
      );
      final event = PingData(
        summary: PingSummary(
          transmitted: 5,
          received: 5,
        ),
      );
      callback(event);
      verify(_bloc.add(any)).called(4);
    });

    test('handles ping response event', () async {
      _setUpPingPhase();
      final List<PingResponse> pings = [];
      final callback = _measurementService.handlePingEvent(
        count: 5,
        progressCount: 0,
        progressPercent: 0,
        pings: pings,
      );
      final event = PingData(
        response: PingResponse(time: Duration(milliseconds: 10)),
        summary: null,
      );
      callback(event);
      verify(_bloc.add(any)).called(1);
      expect(pings.length, 1);
      expect(_measurementService.lastDispatchedEvent, isA<SetPhaseResult>());
    });

    test('ignores ping error event', () async {
      _setUpPingPhase();
      final List<PingResponse> pings = [];
      final callback = _measurementService.handlePingEvent(
        count: 5,
        progressCount: 0,
        progressPercent: 0,
        pings: pings,
      );
      final event = PingData(
        error: PingError.requestTimedOut,
        summary: null,
      );
      callback(event);
      verify(_bloc.add(any)).called(1);
      expect(pings.length, 0);
      expect(_measurementService.lastDispatchedEvent, isA<SetPhaseResult>());
    });

    test('throws error if pings are empty', () async {
      _setUpPingPhase();
      final List<PingResponse> pings = [];
      final callback = _measurementService.handlePingEvent(
        count: 0,
        progressCount: 0,
        progressPercent: 0,
        pings: pings,
      );
      final event = PingData(
        response: PingResponse(time: Duration(milliseconds: 10)),
        summary: null,
      );
      try {
        callback(event);
      } catch (e) {
        expect(e.toString(), MeasurementError.pingFailed.toString());
      }
    });
  });
}

_setUpPingPhase() {
  _measurementService = MeasurementService(channel: _methodChannel);
  _measurementService.lastDispatchedEvent = StartMeasurement();
  _measurementService.lastPhase = MeasurementPhase.fetchingTestParams;
}
