import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/store/core.state.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

import '../../di/service-locator.dart';
import '../../measurements/widgets-tests/home-screen.widget_test.dart';

const String _mapSearchQuery = 'Query';
final NTProject _project =
    NTProject.fromJson({'mapbox_actual_date': '2022-02-03'});

final NTProject _projectDecember =
    NTProject.fromJson({'mapbox_actual_date': '2022-12-03'});
late final CMSService _cmsService;
late final MapCubit cubit;

class MockMapCubit extends MockCubit<MapState> implements MapCubit {}

class MockMapCubitCalls extends Mock implements MapCubit {}

@GenerateMocks([
  MapSearchApiService
], customMocks: [
  MockSpec<TechnologyApiService>(
    onMissingStub: OnMissingStub.returnDefault,
  )
])
void main() {
  setUpAll(() async {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    _setUpStubs(_project);
    cubit = MapCubit();
  });

  group('Test map cubit', () {
    test('loads mobile operators', () async {
      await cubit.loadProviders();
      expect(
        cubit.state.providers.length,
        2,
      );
    });

    test('activates search when the field is tapped', () {
      cubit.onSearchTap(FocusNode());
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
      verify(_cmsService.project).called(1);
      final match = DateTime.parse(_project.mapboxActualDate!);
      expect(cubit.state.defaultPeriod, match);
      expect(cubit.state.currentPeriod, match);

      await cubit.loadDefaultDate();
      verifyNever(_cmsService.project);
      expect(cubit.state.defaultPeriod, match);
      expect(cubit.state.currentPeriod, match);
    });

    test('retrieves default date from the core state', () async {
      final coreState = CoreState(project: _project);
      whenListen(
        GetIt.I.get<CoreCubit>(),
        Stream.fromIterable([coreState]),
        initialState: coreState,
      );
      await cubit.loadDefaultDate();
      verifyNever(_cmsService.getProject());
      final match = DateTime.parse(_project.mapboxActualDate!);
      expect(cubit.state.defaultPeriod, match);
      expect(cubit.state.currentPeriod, match);
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

    test('Switching between ISPs and MNOs', () {
      cubit.onIspMnoSwitch(true);
      expect(cubit.state.technologies, ispTechnologies);
      cubit.onIspMnoSwitch(false);
      expect(cubit.state.technologies, mnoTechnologies);
    });
  });
}

_setUpStubs(NTProject project) {
  final technologyApiService = GetIt.I.get<TechnologyApiService>();
  final mapSearchApiService = GetIt.I.get<MapSearchApiService>();
  _cmsService = GetIt.I.get<CMSService>();
  when(_cmsService.project).thenReturn(project);
  when(technologyApiService.getMnoProviders())
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
  TestingServiceLocator.swapLazySingleton<CoreCubit>(() => MockCoreCubit());
  final coreState = CoreState();
  whenListen(
    GetIt.I.get<CoreCubit>(),
    Stream.fromIterable([coreState]),
    initialState: coreState,
  );
}
