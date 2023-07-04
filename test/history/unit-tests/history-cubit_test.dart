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
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/net-neutrality-history.state.dart';
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

class MockNetNeutralityHistoryCubit extends MockCubit<NetNeutralityHistoryState>
    implements NetNeutralityHistoryCubit {}

final _dioError = MockDioError();
late HistoryCubit _cubit;
final _errorHandler = HistoryErrorHandler();

@GenerateMocks([HistoryApiService])
void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances();
    _cubit = HistoryCubit();
    _setUpStubs(_cubit);
  });

  group('Test history cubit', () {
    test('Test device filters retrieving', () {
      final filters = _cubit.getFiltersFromHistory(
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
      final filters = _cubit.getFiltersFromHistory(
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
      await _cubit.init(errorHandler: _errorHandler);
      await _cubit.onFilterTap(
          _cubit.state.deviceFilters.firstWhere((e) => e.text == 'iPhone'));
      expect(
        _cubit.state.speedHistory,
        [_deviceHistory.firstWhere((e) => e.tests.first.device == 'iPhone')],
      );
    });

    test('does not update state on filter tap with error', () async {
      await _cubit.init(errorHandler: _errorHandler);
      final oldState = _cubit.state;
      await _cubit.onFilterTap(
          _cubit.state.deviceFilters.firstWhere((e) => e.text == 'Android'));
      expect(_cubit.state.speedHistory, oldState.speedHistory);
    });

    test('loads next page', () async {
      await _cubit.init(errorHandler: _errorHandler);
      final oldPage = _cubit.pageNumber;
      final oldState = _cubit.state;
      await _cubit.onEndOfPage();
      expect(
        _cubit.state.speedHistory,
        [...oldState.speedHistory, ...oldState.speedHistory],
      );
      expect(_cubit.pageNumber, oldPage + 1);
    });

    test('does not update state on next page with error', () async {
      await _cubit.init(errorHandler: _errorHandler);
      await _cubit.onEndOfPage();
      final oldPage = _cubit.pageNumber;
      final oldState = _cubit.state;
      await _cubit.onEndOfPage();
      expect(_cubit.state.speedHistory, oldState.speedHistory);
      expect(_cubit.pageNumber, oldPage);
    });

    test('does not download history when it is not enabled', () async {
      final oldState = _cubit.state;
      when(GetIt.I
              .get<SharedPreferencesWrapper>()
              .getBool(StorageKeys.persistentClientUuidEnabled))
          .thenReturn(false);
      await _cubit.init(errorHandler: _errorHandler);
      expect(_cubit.state.speedHistory, oldState.speedHistory);
      expect(_cubit.state.loading, false);
      expect(_cubit.state.isHistoryEnabled, false);
    });

    test('processes errors', () {
      _cubit.processError(_dioError);
      expect(_cubit.state.error, _dioError);
    });
  });
}

_setUpStubs(HistoryCubit cubit) {
  final historyApiService = GetIt.I.get<HistoryApiService>();
  when(historyApiService.getSpeedHistory(1, [], [],
          errorHandler: _errorHandler))
      .thenAnswer((_) async => History(
            content: _deviceHistory,
            totalElements: 2,
            totalPages: 1,
            last: false,
          ));
  when(historyApiService.getSpeedHistory(2, [], [],
          errorHandler: _errorHandler))
      .thenAnswer((_) async => History(
            content: _deviceHistory,
            totalElements: 2,
            totalPages: 1,
            last: true,
          ));
  when(historyApiService.getSpeedHistory(3, [], [],
          errorHandler: _errorHandler))
      .thenAnswer((_) async => null);
  when(historyApiService.getSpeedHistory(1, [], ['iPhone'],
          errorHandler: _errorHandler))
      .thenAnswer((_) async => History(
            content: [
              _deviceHistory.firstWhere((e) => e.tests.first.device == 'iPhone')
            ],
            totalElements: 1,
            totalPages: 1,
            last: true,
          ));
  when(historyApiService.getSpeedHistory(1, [], ['Android'],
          errorHandler: _errorHandler))
      .thenAnswer((_) async => null);
  when(GetIt.I
          .get<SharedPreferencesWrapper>()
          .getBool(StorageKeys.persistentClientUuidEnabled))
      .thenReturn(true);
}
