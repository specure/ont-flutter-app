import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';

import '../../di/service-locator.dart';

const String _mapSearchQuery = 'Query';
final NTProject _project =
    NTProject.fromJson({'mapbox_actual_date': '2022-02-03'});

final NTProject _projectDecember =
    NTProject.fromJson({'mapbox_actual_date': '2022-12-03'});
late final _cmsService;
late final MapCubit cubit;

@GenerateMocks([TechnologyApiService, MapSearchApiService])
void main() {
  setUpAll(() async {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _setUpStubs(_project);
    cubit = MapCubit();
  });

  group('Test map cubit', () {
    test('loads mobile operators', () async {
      await cubit.loadMobileNetworkOperators();
      expect(
        cubit.state.mobileNetworkOperators.length,
        2,
      );
    });
    test('activates search when the field is tapped', () {
      cubit.onSearchTap();
      expect(cubit.state.isSearchActive, true);
    });
    test('cancels search', () {
      cubit.onCancelSearchTap();
      expect(cubit.state.isSearchActive, false);
      expect(cubit.state.searchResults, isEmpty);
    });
    test('returns results when searching', () async {
      await cubit.onSearchEdit(_mapSearchQuery);
      expect(
        cubit.state.searchResults,
        isNotEmpty,
      );
    });
    test('retrieves data from map layers', () {
      final List<dynamic> data = [
        {
          "properties": {
            "202001-ALL-ALL-COUNT": 80,
            "202001-ALL-ALL-DOWNLOAD": 10.15,
            "202001-ALL-ALL-UPLOAD": 20.65,
            "202001-ALL-ALL-PING": 80
          }
        }
      ];
      final measurementsData = cubit.getMeasurementsDataFromMap(data, 5.0);
      expect(measurementsData, isNotNull);
    });
    test('retrieves default date from the CMS', () async {
      await cubit.loadDefaultDate();
      final match = DateTime.parse(_project.mapboxActualDate!);
      expect(cubit.state.defaultPeriod, match);
      expect(cubit.state.currentPeriod, match);
    });
    test('requests and sets the default date once', () async {
      await cubit.loadDefaultDate();
      verify(_cmsService.getProject()).called(1);
      await cubit.loadDefaultDate();
      verifyNever(_cmsService.getProject());
    });
    test('Checking last month of the year', () async {
      when(_cmsService.getProject()).thenAnswer((_) async => _projectDecember);
      var periodPickerMonthsList = cubit.periodPickerMonthsList;
      expect(periodPickerMonthsList.length, 2);

      var periodPickerYearsList = cubit.periodPickerYearsList;
      expect(periodPickerYearsList.length, 3);
    });
    // test('Checking last month of the year', () async {
    //   DateTime date = DateTime.now();
    //   DateTime decemberDate = DateTime(date.year, DateTime.december, date.day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
    //   when(DateTime.now()).thenAnswer((_) => decemberDate);
    //   var periodPickerMonthsList = cubit.periodPickerMonthsList;
    //   expect(periodPickerMonthsList.length, 2);
    //
    //   var periodPickerYearsList = cubit.periodPickerYearsList;
    //   expect(periodPickerYearsList.length, 3);
    //
    //   var periodPickerMonthsListDec = cubit.periodPickerMonthsList;
    //   expect(periodPickerMonthsListDec.length, 12);
    //
    //   var periodPickerYearsListDec = cubit.periodPickerYearsList;
    //   expect(periodPickerYearsListDec.length, 2);
    // });
  });
}

_setUpStubs(NTProject project) {
  final technologyApiService = GetIt.I.get<TechnologyApiService>();
  final mapSearchApiService = GetIt.I.get<MapSearchApiService>();
  _cmsService = GetIt.I.get<CMSService>();
  when(_cmsService.getProject()).thenAnswer((_) async => project);
  when(technologyApiService.getMobileOperators())
      .thenAnswer((_) async => ['Operator']);
  when(mapSearchApiService.search(MapSearchRequest(
    _mapSearchQuery,
    MapBoxConsts.initialLat,
    MapBoxConsts.initialLng,
    MapBoxConsts.countryCode,
  ))).thenAnswer((_) async => [
        MapSearchItem(
          title: 'Infinite Loop, Cupertino, CA 95014, United States',
          address: 'Infinite Loop, Cupertino, CA 95014, United States',
          latitude: 10.0,
          longitude: 20.0,
          bounds: LatLngBounds(
            southwest: LatLng(10.0, 20.0),
            northeast: LatLng(10.0, 20.0),
          ),
        ),
      ]);

  final dateTimeWrapper = GetIt.I.get<DateTimeWrapper>();
  final now = DateTime(2022, 2, 3);
  when(dateTimeWrapper.now()).thenReturn(now);
  when(dateTimeWrapper.defaultCalendarDateTime()).thenReturn(now);
}
