import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUpAll(() {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
    when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  });

  group('Test mobile operators API', () {
    test('returns a list when the request is successful', () async {
      when(GetIt.I.get<Dio>().get('***REMOVED***')).thenAnswer((_) async =>
          Response(
              requestOptions: RequestOptions(path: '***REMOVED***'),
              statusCode: 200,
              data: {
                'statsByProvider': [
                  {'providerName': 'Name'}
                ],
              }));
      List<String> list =
          await TechnologyApiService(testing: true).getMobileOperators();
      expect(list, ['Name']);
    });
    test('returns an empty list when the request fails', () async {
      when(GetIt.I.get<Dio>().get('***REMOVED***'))
          .thenAnswer((_) async => throw MockDioError());
      List<String> list =
          await TechnologyApiService(testing: true).getMobileOperators();
      expect(list, []);
    });
  });
}
