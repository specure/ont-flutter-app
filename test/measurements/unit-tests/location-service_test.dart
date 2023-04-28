import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/location-model.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/wrappers/geocoding-wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/location.service.dart';

import '../../di/service-locator.dart';

const String _address = 'Infinite Loop, Cupertino, CA 95014, United States';
const int _timestamp = 1234567;
const double _latitude = 10;
const double _longitude = 20;
const String _country = 'United States';
const String _city = 'Cupertino';
const String _county = 'Cupertino';
const String _postalCode = '94024';

@GenerateMocks([GeocodingWrapper])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  group('Location tests', () {
    TestingServiceLocator.registerInstances();
    _setUpStubs();
    test('Test address by location', () async {
      await _testAddressByLocation();
    });
    test('Test coordinates by name', () async {
      await _testCoordinatesByName();
    });
  });
}

Future _testAddressByLocation() async {
  expect(
    await LocationService(testing: true)
        .getAddressByLocation(_latitude, _longitude),
    LocationModel(
      latitude: _latitude,
      longitude: _longitude,
      city: _city,
      country: _country,
      county: _county,
      postalCode: _postalCode,
    ),
  );
}

Future _testCoordinatesByName() async {
  expect(
    await LocationService(testing: true).getCoordinatesByName(_address),
    LatLng(_latitude, _longitude),
  );
}

_setUpStubs() {
  final geocoding = GetIt.I.get<GeocodingWrapper>();
  when(geocoding.getPlaceMarksFromCoordinates(_latitude, _longitude))
      .thenAnswer((_) async => [
            Placemark(
              country: _country,
              administrativeArea: _county,
              locality: _city,
              postalCode: _postalCode,
            )
          ]);
  when(geocoding.getLocationFromAddress(_address)).thenAnswer((_) async => [
        Location(
          latitude: _latitude,
          longitude: _longitude,
          timestamp: DateTime.fromMillisecondsSinceEpoch(_timestamp),
        )
      ]);
}
