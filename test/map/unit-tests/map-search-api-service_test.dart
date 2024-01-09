import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

const String _query = 'Query';
const String _queryWithoutResults = 'Query without results';
const double _lat = 10;
const double _lng = 20;
const String _countryCode = 'US';
final DioException _dioError = MockDioError();

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    _setUpStubs();
  });

  group('Map search', () {
    test('returns a list when the search is successfull', () async {
      final request = MapSearchRequest(_query, _lat, _lng, _countryCode);
      List<MapSearchItem> items =
          await MapSearchApiService(testing: true).search(request);
      expect(items, isNotEmpty);
    });

    test('returns no results when search fails', () async {
      final request =
          MapSearchRequest(_queryWithoutResults, _lat, _lng, _countryCode);
      List<MapSearchItem> items =
          await MapSearchApiService(testing: true).search(request);
      expect(items, isEmpty);
    });
  });
}

_setUpStubs() {
  final dio = GetIt.I.get<Dio>();
  when(dio.get('/v1/geocode', queryParameters: {
    'q': _query,
    'at': '${_lat.toString()},${_lng.toString()}',
    'in': 'countryCode:$_countryCode',
    'limit': 10,
    'apiKey': dotenv.env['HERE_API_TOKEN'],
  })).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/v1/geocode'),
        statusCode: 200,
        data: {
          'items': [
            {
              'title': 'Infinite Loop, Cupertino, CA 95014, United States',
              'address': {
                'label': 'Infinite Loop, Cupertino, CA 95014, United States',
              },
              'position': {
                'lat': _lat,
                'lng': _lng,
              },
              'mapView': {
                "west": 10.0,
                "south": 20.0,
                "east": 10.0,
                "north": 20.0,
              },
            }
          ],
        },
      ));
  when(dio.get('/v1/geocode', queryParameters: {
    'q': _queryWithoutResults,
    'at': '${_lat.toString()},${_lng.toString()}',
    'in': 'countryCode:$_countryCode',
    'limit': 10,
    'apiKey': dotenv.env['HERE_API_TOKEN'],
  })).thenThrow(_dioError);
}
