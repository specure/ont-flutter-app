import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/network.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-phase.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/dns-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-settings-response.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/web-net-neutrality-result-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-measurement/net-neutrality-measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result/net-neutrality-result.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-measurement.service.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

import '../../di/service-locator.dart';

late NetNeutralityCubit _cubit;
final _errorHandler = NetNeutralityCubitErrorHandler();
final _settings = NetNeutralitySettingsResponse.fromJson(jsonDecode(
    File('test/net-neutrality/unit-tests/data/net-neutrality-settings.json')
        .readAsStringSync()));
const _ipV4PublicAddress = '192.168.0.0';
const _ipV4PrivateAddress = '192.168.0.1';
const _ipV6Address = '2001:0db8:85a3:0000:0000:8a2e:0370:7334';
const _carrierName = 'Provider';
const _radioType = 'LTE';
const _networkGeneration = '4g';

List<SignalInfo> _allSignals4gLteCa = (jsonDecode(File(
            'test/measurements/unit-tests/data/allPrimaryDataCellSignalInfo4gLteCa.json')
        .readAsStringSync()) as List)
    .map((signalInfo) => SignalInfo.fromJson(signalInfo))
    .toList();

final _networkInfoDetails = NetworkInfoDetails(
  type: _radioType,
  name: _carrierName,
  mobileNetworkGeneration: _networkGeneration,
  ipV4PrivateAddress: _ipV4PrivateAddress,
  ipV4PublicAddress: _ipV4PublicAddress,
  ipV6PrivateAddress: _ipV6Address,
  ipV6PublicAddress: _ipV6Address,
  currentAllSignalInfo: _allSignals4gLteCa,
  telephonyNetworkSimOperator: '231-06',
  telephonyNetworkSimOperatorName: "O2-SK",
  telephonyNetworkIsRoaming: false,
  telephonyNetworkOperator: '231-06',
  telephonyNetworkOperatorName: "O2-SK",
  telephonyNetworkCountry: 'sk',
  telephonyNetworkSimCountry: 'sk',
);
final _webResultItem = WebNetNeutralityResultItem(
  id: 0,
  openTestUuid: '',
  durationNs: 1,
  timeoutExceeded: false,
  type: '',
);
final _dnsResultItem = DnsNetNeutralityResultItem(
  id: 0,
  openTestUuid: '',
  durationNs: 1,
  timeoutExceeded: false,
  type: '',
  dnsStatus: '',
  resolver: '',
  dnsEntries: [''],
);

@GenerateMocks([], customMocks: [
  MockSpec<NetNeutralityMeasurementService>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
  MockSpec<NetNeutralityApiService>(
    onMissingStub: OnMissingStub.returnDefault,
  ),
])
class TestNetNeutralityCubit extends NetNeutralityCubit {
  TestNetNeutralityCubit({required ErrorHandler errorHandler})
      : super(errorHandler: errorHandler);

  @override
  showFinishedStateDelay() async {}
}

void main() {
  setUp(() async {
    TestingServiceLocator.registerInstances();
    _cubit = TestNetNeutralityCubit(errorHandler: _errorHandler);
    TestingServiceLocator.swapLazySingleton<NetNeutralityCubit>(() => _cubit);
    when(GetIt.I.get<NetworkService>().subscribeToNetworkChanges(
            changesHandler: anyNamed('changesHandler')))
        .thenReturn(Stream.fromIterable([]).listen((event) {}));
    when(GetIt.I
            .get<NavigationService>()
            .pushNamed(NetNeutralityMeasurementScreen.route))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<NavigationService>()
            .pushReplacementRoute(NetNeutralityResultScreen.route, null))
        .thenAnswer(
      (realInvocation) async => null,
    );
    when(GetIt.I.get<NavigationService>().goBack())
        .thenAnswer((realInvocation) => null);
    when(GetIt.I
            .get<NetNeutralityApiService>()
            .getSettings(errorHandler: _errorHandler))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<NetNeutralityApiService>()
            .getHistory(_settings.openTestUuid, errorHandler: _errorHandler))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I
            .get<NetNeutralityMeasurementService>()
            .initWithSettings(_settings))
        .thenAnswer((realInvocation) async => null);
    when(GetIt.I.get<NetNeutralityMeasurementService>().settings)
        .thenReturn(_settings);
    when(GetIt.I.get<NetNeutralityMeasurementService>().runAllWebPageTests())
        .thenAnswer((realInvocation) {
      return null;
    });
    when(GetIt.I.get<NetNeutralityMeasurementService>().runAllDnsTests())
        .thenAnswer((realInvocation) {
      return null;
    });
    final networkService = GetIt.I.get<NetworkService>();
    when(networkService.getAllNetworkDetails())
        .thenAnswer((_) async => _networkInfoDetails);
    when(GetIt.I.get<PlatformWrapper>().isAndroid).thenReturn(false);
    when(GetIt.I.get<PlatformWrapper>().isIOS).thenReturn(true);
    when(GetIt.I.get<DeviceInfoPlugin>().iosInfo)
        .thenAnswer((_) async => IosDeviceInfo.fromMap({
              'isPhysicalDevice': false,
              'name': 'iPhone',
              'utsname': {
                'sysname': 'iPhone',
                'nodename': 'iPhone',
                'release': '14.0',
                'version': '14.0',
                'machine': 'iPhone',
              },
              'systemName': 'iOS',
              'systemVersion': '14.0',
              'model': 'iPhone',
              'modelName': 'iPhone',
              'localizedModel': 'iPhone',
              'identifierForVendor': 'identifierForVendor',
              'isiOSAppOnMac': false,
            }));
    when(GetIt.I.get<LocationService>().latestLocation)
        .thenAnswer((_) async => null);
  });

  group("Net Neutrality Cubit", () {
    test('init', () async {
      await _cubit.init();
      verify(GetIt.I.get<NetworkService>().subscribeToNetworkChanges(
              changesHandler: anyNamed('changesHandler')))
          .called(1);
    });

    blocTest<NetNeutralityCubit, NetNeutralityState>(
      'startMeasurement with error',
      build: () => _cubit,
      act: (cubit) {
        cubit.startMeasurement();
      },
      expect: () => [
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 0,
          phase: NetNeutralityPhase.fetchingSettings,
          interimResults: [],
        ),
        _cubit.state.copyWith(
          phase: NetNeutralityPhase.none,
          error: NetNeutralityCubit.noSettingsException,
        )
      ],
    );

    blocTest<NetNeutralityCubit, NetNeutralityState>(
      'startMeasurement',
      build: () => _cubit,
      act: (cubit) {
        when(GetIt.I
                .get<NetNeutralityApiService>()
                .getSettings(errorHandler: anyNamed('errorHandler')))
            .thenAnswer((realInvocation) async => _settings);
        cubit.startMeasurement();
        cubit.updateProgress(
          resultItem: _webResultItem,
        );
        cubit.updateProgress(
          resultItem: _dnsResultItem,
        );
      },
      expect: () => [
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 0,
          phase: NetNeutralityPhase.fetchingSettings,
          interimResults: [],
        ),
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 50,
          phase: NetNeutralityPhase.runningTests,
          interimResults: [_webResultItem],
        ),
        _cubit.state.copyWith(
          lastResultForCurrentPhase:
              NetNeutralityCubit.MAXIMUM_PERCENTAGE_FOR_EXECUTION_PART,
          phase: NetNeutralityPhase.submittingResult,
          interimResults: [_webResultItem, _dnsResultItem],
        ),
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 100,
          phase: NetNeutralityPhase.submittingResult,
          interimResults: [_webResultItem, _dnsResultItem],
        ),
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 100,
          phase: NetNeutralityPhase.finish,
          interimResults: [_webResultItem, _dnsResultItem],
        ),
      ],
    );

    blocTest<NetNeutralityCubit, NetNeutralityState>(
      'restartMeasurement',
      build: () => _cubit,
      act: (cubit) => cubit.restartMeasurement(),
      expect: () => [
        _cubit.state.copyWith(phase: NetNeutralityPhase.none),
        _cubit.state.copyWith(
          lastResultForCurrentPhase: 0,
          phase: NetNeutralityPhase.fetchingSettings,
          interimResults: [],
        ),
        _cubit.state.copyWith(
          phase: NetNeutralityPhase.none,
          error: NetNeutralityCubit.noSettingsException,
        )
      ],
      verify: (_) {
        verify(GetIt.I.get<NavigationService>().goBack());
      },
    );

    blocTest<NetNeutralityCubit, NetNeutralityState>(
      'connectiviyChangesHandler',
      build: () => _cubit,
      act: (cubit) =>
          cubit.connectivityChangesHandler?.process(ConnectivityResult.wifi),
      expect: () => [
        _cubit.state.copyWith(connectivity: ConnectivityResult.wifi),
      ],
    );

    blocTest<NetNeutralityCubit, NetNeutralityState>(
      'errorHandler',
      build: () => _cubit,
      act: (cubit) {
        cubit.errorHandler?.process(NetNeutralityCubit.noSettingsException);
      },
      expect: () => [
        _cubit.state.copyWith(
          error: NetNeutralityCubit.noSettingsException,
          phase: NetNeutralityPhase.none,
        )
      ],
    );
  });
}
