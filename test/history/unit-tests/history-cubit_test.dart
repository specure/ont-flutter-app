import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/models/history-filter.item.dart';
import 'package:nt_flutter_standalone/modules/history/models/history.dart';
import 'package:nt_flutter_standalone/modules/history/services/api/history.api.service.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/services/net-neutrality-api.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final _deviceHistory = [
  MeasurementHistoryResults([
    MeasurementHistoryResult(
      testUuid: 'uuid',
      downloadKbps: 1000,
      uploadKbps: 1000,
      pingMs: 100,
      userExperienceMetrics: [],
      measurementDate: '2020-01-01T15:00:00.000Z',
      device: 'iPhone',
    )
  ]),
  MeasurementHistoryResults([
    MeasurementHistoryResult(
      testUuid: 'uuid',
      downloadKbps: 1000,
      uploadKbps: 1000,
      pingMs: 100,
      userExperienceMetrics: [],
      measurementDate: '2020-01-02T15:00:00.000Z',
      device: 'Android',
    )
  ]),
];

final _networkTypeHistory = [
  MeasurementHistoryResult(
    testUuid: 'uuid',
    downloadKbps: 1000,
    uploadKbps: 1000,
    pingMs: 100,
    userExperienceMetrics: [],
    measurementDate: '2020-01-03T15:00:00.000Z',
    networkType: '4G',
  ),
  MeasurementHistoryResult(
    testUuid: 'uuid',
    downloadKbps: 1000,
    uploadKbps: 1000,
    pingMs: 100,
    userExperienceMetrics: [],
    measurementDate: '2020-01-04T15:00:00.000Z',
    networkType: '3G',
  ),
];

class MockHistoryCubit extends MockCubit<HistoryState>
    implements HistoryCubit {}

final _dioError = MockDioError();

@GenerateMocks([HistoryApiService])
void main() {
  group('Test history cubit', () {
    TestingServiceLocator.registerInstances();
    final cubit = HistoryCubit();
    _setUpStubs(cubit);
    test('Test device filters retrieving', () {
      final filters = cubit.getFiltersFromHistory(
          _deviceHistory.expand((element) => {...element.tests}).toList(),
          MeasurementHistoryResult.deviceField);
      expect(
        filters,
        [
          HistoryFilterItem(text: 'iPhone'),
          HistoryFilterItem(text: 'Android'),
        ],
      );
    });

    test('Test network type filters retrieving', () {
      final filters = cubit.getFiltersFromHistory(
          _networkTypeHistory, MeasurementHistoryResult.networkTypeField);
      expect(
        filters,
        [
          HistoryFilterItem(text: '4G'),
          HistoryFilterItem(text: '3G'),
        ],
      );
    });

    test('Test on filter tap', () async {
      await cubit.init();
      await cubit.onFilterTap(
          cubit.state.deviceFilters.firstWhere((e) => e.text == 'iPhone'));
      expect(
        cubit.state.speedHistory,
        [_deviceHistory.firstWhere((e) => e.tests.first.device == 'iPhone')],
      );
    });

    test('does not update state on filter tap with error', () async {
      await cubit.init();
      final oldState = cubit.state;
      await cubit.onFilterTap(
          cubit.state.deviceFilters.firstWhere((e) => e.text == 'Android'));
      expect(cubit.state.speedHistory, oldState.speedHistory);
    });

    test('loads next page', () async {
      await cubit.init();
      final oldPage = cubit.historySpeedPage;
      final oldState = cubit.state;
      await cubit.onEndOfSpeedPage();
      expect(
        cubit.state.speedHistory,
        [...oldState.speedHistory, ...oldState.speedHistory],
      );
      expect(cubit.historySpeedPage, oldPage + 1);
    });

    test('does not update state on next page with error', () async {
      await cubit.init();
      await cubit.onEndOfSpeedPage();
      final oldPage = cubit.historySpeedPage;
      final oldState = cubit.state;
      await cubit.onEndOfSpeedPage();
      expect(cubit.state.speedHistory, oldState.speedHistory);
      expect(cubit.historySpeedPage, oldPage);
    });

    test('does not download history when it is not enabled', () async {
      final oldState = cubit.state;
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(false);
      await cubit.init();
      expect(cubit.state.speedHistory, oldState.speedHistory);
      expect(cubit.state.netNeutralityHistory, oldState.netNeutralityHistory);
      expect(cubit.state.loading, false);
      expect(cubit.state.isHistoryEnabled, false);
    });

    test('processes errors', () {
      cubit.process(_dioError);
      expect(cubit.state.error, _dioError);
    });
  });
}

_setUpStubs(HistoryCubit cubit) {
  final historyApiService = GetIt.I.get<HistoryApiService>();
  final netNeutralityApiService = GetIt.I.get<NetNeutralityApiService>();
  when(historyApiService.getSpeedHistory(1, [], [], errorHandler: cubit))
      .thenAnswer((_) async => History(
            content: _deviceHistory,
            totalElements: 2,
            totalPages: 1,
            last: false,
          ));
  when(historyApiService.getSpeedHistory(2, [], [], errorHandler: cubit))
      .thenAnswer((_) async => History(
            content: _deviceHistory,
            totalElements: 2,
            totalPages: 1,
            last: true,
          ));
  when(historyApiService.getSpeedHistory(3, [], [], errorHandler: cubit))
      .thenAnswer((_) async => null);
  when(historyApiService.getSpeedHistory(1, [], ['iPhone'],
          errorHandler: cubit))
      .thenAnswer((_) async => History(
            content: [
              _deviceHistory.firstWhere((e) => e.tests.first.device == 'iPhone')
            ],
            totalElements: 1,
            totalPages: 1,
            last: true,
          ));
  when(historyApiService.getSpeedHistory(1, [], ['Android'],
          errorHandler: cubit))
      .thenAnswer((_) async => null);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.persistentClientUuidEnabled))
      .thenReturn(true);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.netNeutralityTestsEnabled))
      .thenReturn(true);
  when(netNeutralityApiService.getWholeHistory(1, errorHandler: cubit))
      .thenAnswer((_) async => null);
}
