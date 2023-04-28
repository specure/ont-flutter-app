import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-results.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

late MeasurementResultCubit _cubit;
final _testUuid = 'testUuid';
final _result = MeasurementHistoryResults([MeasurementHistoryResult(
  testUuid: _testUuid,
  uploadKbps: 30,
  downloadKbps: 30,
  pingMs: 30,
  measurementDate: 'measurementDate',
  measurementServerCity: 'Huston',
)]);
final _dioError = MockDioError();

@GenerateMocks(
  [MeasurementResultService, MapboxMapController],
)
void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    TestingServiceLocator.registerInstances();
    _cubit = MeasurementResultCubit();
    when(GetIt.I.get<MeasurementResultService>().getResultWithSpeedCurves(
          _testUuid,
          result: _result.tests.first,
          errorHandler: _cubit,
        )).thenAnswer((realInvocation) async => _result.tests.first);
  });

  group('Measurement result cubit', () {
    blocTest<MeasurementResultCubit, MeasurementResultState>(
      'init',
      build: () => _cubit,
      act: (cubit) => cubit.init(result: _result, testUuid: _testUuid),
      expect: () => [
        MeasurementResultState(loading: true),
        MeasurementResultState(loading: false, result: _result.tests.first),
      ],
    );
    blocTest<MeasurementResultCubit, MeasurementResultState>(
      'error',
      build: () => _cubit,
      act: (cubit) => cubit.process(_dioError),
      expect: () => [
        MeasurementResultState(error: _dioError),
      ],
    );
    blocTest<MeasurementResultCubit, MeasurementResultState>(
      'get methodology page',
      build: () => _cubit,
      act: (bloc) async {
        when(GetIt.I
                .get<CMSService>()
                .getDescription('methodology', errorHandler: _cubit))
            .thenAnswer((_) async => 'test');
        when(GetIt.I.get<CMSService>().getPageUrl('methodology'))
            .thenAnswer((_) => 'test.com');
        return await bloc.getPage('methodology');
      },
      expect: () => [
        MeasurementResultState().copyWith(
          loading: true,
        ),
        MeasurementResultState().copyWith(
          staticPageContent: 'test',
          staticPageUrl: 'test.com',
        ),
      ],
    );
    blocTest<MeasurementResultCubit, MeasurementResultState>(
      'get methodology url',
      build: () => _cubit,
      act: (bloc) async {
        when(GetIt.I.get<CMSService>().getPageUrl('methodology#qoe'))
            .thenAnswer((_) => 'test.com/methodology#qoe');
        return await bloc.getPage('methodology#qoe',
            pageContent: 'qoe estimation');
      },
      expect: () => [
        MeasurementResultState().copyWith(
          loading: false,
          staticPageUrl: 'test.com/methodology#qoe',
          staticPageContent: 'qoe estimation',
        ),
      ],
    );
  });
}
