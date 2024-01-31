import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/date-time.wrapper.dart';
import 'package:nt_flutter_standalone/modules/map/constants/colors.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.request.dart';
import 'package:nt_flutter_standalone/modules/map/models/measurements.data.dart';
import 'package:nt_flutter_standalone/modules/map/models/technology.item.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/map-search.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/services/api/technology.api.service.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/measurements.popup.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/period-picker.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/providers.bottom-sheet.dart';

const int PICKER_YEARS_COUNT = 2;

List<TechnologyItem> mnoTechnologies = [
  TechnologyItem(
    color: NTColors.primary,
    title: 'All',
  ),
  TechnologyItem(
    color: color2G,
    title: '2G',
  ),
  TechnologyItem(
    color: color3G,
    title: '3G',
  ),
  TechnologyItem(
    color: color4G,
    title: '4G',
  ),
  TechnologyItem(
    color: color5G,
    title: '5G',
  ),
];

List<TechnologyItem> ispTechnologies = [
  TechnologyItem(
    color: NTColors.primary,
    title: 'WLAN',
  ),
];

class MapCubit extends Cubit<MapState> {
  final NavigationService _navigationService = GetIt.I.get<NavigationService>();
  final MapSearchApiService _mapSearchService =
      GetIt.I.get<MapSearchApiService>();
  final TechnologyApiService _technologyService =
      GetIt.I.get<TechnologyApiService>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();
  final DateTimeWrapper _dateTimeWrapper = GetIt.I.get<DateTimeWrapper>();
  MaplibreMapController? _mapController;

  Timer? _debounce;

  final List<String> _periodPickerMonthsList = List.generate(
    12,
    (index) => DateFormat('MMMM').format(DateTime(0, 12 - index)),
    growable: false,
  );

  late List<String> _periodPickerYearsList = List.generate(
    _dateTimeWrapper.now().month % 12 == 0
        ? PICKER_YEARS_COUNT
        : PICKER_YEARS_COUNT + 1,
    (index) => (_dateTimeWrapper.now().year - index).toString(),
    growable: false,
  ).toList();

  List<String> get periodPickerMonthsList {
    var list;
    var currentMonth = _dateTimeWrapper.now().month;
    switch (state.currentPeriodPickerYearIndex) {
      case 0:
        list = _periodPickerMonthsList.sublist(12 - currentMonth);
        break;
      case PICKER_YEARS_COUNT:
        list = _periodPickerMonthsList.sublist(0, 12 - currentMonth);
        break;
      default:
        list = _periodPickerMonthsList;
    }
    return list;
  }

  List<String> get periodPickerYearsList => _periodPickerYearsList;

  String? get currentDateString => state.currentPeriod != null
      ? DateFormat('yyyyMM').format(state.currentPeriod!)
      : null;
  String get currentTechnology =>
      state.technologies[state.currentTechnologyIndex].title.toUpperCase();
  String get currentMobileOperator =>
      state.providers[state.currentProviderIndex]
          .toUpperCase()
          .replaceAll(RegExp(r'\s+'), '-');
  String get currentLayerAffix =>
      '$currentDateString-$currentTechnology-$currentMobileOperator';
  String get currentLayerPrefix {
    var prefix = '';
    var zoom = _mapController?.cameraPosition?.zoom ?? 0;
    if (zoom <= MapBoxConsts.zoomLevelC) {
      prefix = 'C';
    } else if (zoom <= MapBoxConsts.zoomLevelM) {
      prefix = 'M';
    } else if (zoom <= MapBoxConsts.zoomLevelH10) {
      prefix = 'H10';
    } else if (zoom <= MapBoxConsts.zoomLevelH1) {
      prefix = 'H1';
    } else if (zoom <= MapBoxConsts.zoomLevelH01) {
      prefix = 'H01';
    } else {
      prefix = 'H001';
    }
    return prefix;
  }

  MapCubit()
      : super(MapState(
          providers: ['All'],
          technologies: mnoTechnologies,
          currentPeriod:
              GetIt.I.get<DateTimeWrapper>().defaultCalendarDateTime(),
        ));

  init() async {
    await loadDefaultDate();
    await loadProviders();
  }

  Future loadDefaultDate() async {
    if (state.defaultPeriod != null) {
      return;
    }
    final NTProject? project = GetIt.I.get<CoreCubit>().state.project ??
        await _cmsService.getProject();
    if (project != null && project.mapboxActualDate != null) {
      final DateTime currentPeriod = DateTime.parse(project.mapboxActualDate!);
      emit(state.copyWith(
        currentPeriod: currentPeriod,
        defaultPeriod: currentPeriod,
      ));
    }
  }

  Future loadProviders({bool isIspActive = false}) async {
    List<String> providers = [];
    if (isIspActive) {
      providers = await _technologyService.getIspProviders();
    } else {
      providers = await _technologyService.getMnoProviders();
    }
    providers.insert(0, 'All');
    emit(state.copyWith(providers: providers));
  }

  void onMapCreated(MaplibreMapController controller) {
    _mapController = controller;
  }

  void onMapStyleLoaded() {
    _showCurrentLayer();
  }

  Future _showCurrentLayer() async {
    if (_mapController == null) {
      return;
    }
    final allLayers = await _mapController!.getLayerIds();
    final dataLayers = allLayers.where((el) {
      final layerId = el as String;
      return (layerId.startsWith('C-') ||
              layerId.startsWith('M-') ||
              layerId.startsWith('H1') ||
              layerId.startsWith('H0')) &&
          layerId != 'C-Borders' &&
          layerId != 'M-Borders';
    });
    await Future.wait(
      dataLayers.map(
        (layerId) => _mapController!.setLayerVisibility(layerId, false),
      ),
    );
    return Future.wait([
      _mapController!.setLayerVisibility('C-$currentLayerAffix', true),
      _mapController!.setLayerVisibility('M-$currentLayerAffix', true),
      _mapController!.setLayerVisibility('H10-$currentLayerAffix', true),
      _mapController!.setLayerVisibility('H1-$currentLayerAffix', true),
      _mapController!.setLayerVisibility('H01-$currentLayerAffix', true),
      _mapController!.setLayerVisibility('H001-$currentLayerAffix', true),
    ]);
  }

  void onCancelSearchTap() {
    emit(state.copyWith(isSearchActive: false, searchResults: []));
  }

  void onSearchTap(FocusNode focusNode) {
    focusNode.requestFocus();
    emit(state.copyWith(isSearchActive: true));
  }

  Future? onSearchEdit(String query) {
    if ((_debounce?.isActive) ?? false) {
      _debounce?.cancel();
    }
    final completer = Completer();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      List<MapSearchItem> searchResult =
          await _mapSearchService.search(MapSearchRequest(
        query,
        MapBoxConsts.initialLat,
        MapBoxConsts.initialLng,
        MapBoxConsts.countryCode,
      ));
      emit(state.copyWith(searchResults: searchResult));
      completer.complete();
    });
    return completer.future;
  }

  void onSearchResultTap(MapSearchItem item) {
    if (item.bounds != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(item.bounds!));
    } else {
      _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(item.latitude, item.longitude)));
    }
    Future.delayed(Duration(milliseconds: 500), () => onCancelSearchTap());
  }

  void onTechnologyBarTap() {
    emit(state.copyWith(
        isTechnologyBarExpanded: !state.isTechnologyBarExpanded));
  }

  Future onTechnologyTap(TechnologyItem technology) async {
    emit(state.copyWith(
        currentTechnologyIndex: state.technologies.indexOf(technology)));
    _showCurrentLayer();
  }

  Future onOperatorChange(String operator) async {
    emit(state.copyWith(
        currentProviderIndex: state.providers.indexOf(operator)));
    _showCurrentLayer();
  }

  Future pickPeriod() async {
    int month = state.currentPeriodPickerMonthIndex >=
                periodPickerMonthsList.length ||
            state.currentPeriodPickerMonthIndex < 0
        ? 0
        : DateFormat('MMMM')
            .parse(periodPickerMonthsList[state.currentPeriodPickerMonthIndex])
            .month;
    var date = DateTime(
      int.parse(periodPickerYearsList[state.currentPeriodPickerYearIndex]),
      month,
    );
    emit(state.copyWith(currentPeriod: date));
    _showCurrentLayer();
  }

  void onPeriodPickerYearIndexChange(int index) {
    var monthsDifference = (index == 0 ? _dateTimeWrapper.now().month : 12) -
        periodPickerMonthsList.length;
    var newPeriodPickerMonthIndex =
        monthsDifference + state.currentPeriodPickerMonthIndex;
    emit(state.copyWith(
      currentPeriodPickerYearIndex: index,
      currentPeriodPickerMonthIndex: newPeriodPickerMonthIndex,
    ));
    pickPeriod();
  }

  void onPeriodPickerMonthIndexChange(int index) {
    emit(state.copyWith(currentPeriodPickerMonthIndex: index));
    pickPeriod();
  }

  void onPeriodBadgeTap() {
    emit(state.copyWith(
      currentPeriodPickerYearIndex:
          periodPickerYearsList.indexOf(state.currentPeriod!.year.toString()),
      currentPeriodPickerMonthIndex: periodPickerMonthsList
          .indexOf(DateFormat('MMMM').format(state.currentPeriod!)),
    ));
    _navigationService.showBottomSheet(
      PeriodPicker(),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
    );
  }

  void onProvidersTap() {
    _navigationService.showBottomSheet(
      ProvidersBottomSheet(
        providers: state.providers,
        onProviderTap: onOperatorChange,
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
    );
  }

  Future onMapClick(Point<double> point, LatLng latlng) async {
    List queriedDataFromMap = await _mapController?.queryRenderedFeatures(
          point,
          ['$currentLayerPrefix-$currentLayerAffix'],
          null,
        ) ??
        [];
    final zoom = _mapController?.cameraPosition?.zoom ?? 0;
    final measurementsData =
        getMeasurementsDataFromMap(queriedDataFromMap, zoom);
    _navigationService.showBottomSheet(
      MeasurementsPopup(measurementsData),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
    );
  }

  MeasurementsData getMeasurementsDataFromMap(
    List queriedDataFromMap,
    double zoom,
  ) {
    final Map properties = queriedDataFromMap.firstWhere(
        (feature) => feature['properties']['$currentLayerAffix-COUNT'] != null,
        orElse: () => {'properties': {}})['properties'];
    var regionType;
    if (zoom > MapBoxConsts.zoomLevelM) {
      regionType = '';
    } else if (zoom <= MapBoxConsts.zoomLevelC) {
      regionType = 'County';
    } else {
      regionType = 'Municipality';
    }
    return MeasurementsData(
      regionType: regionType,
      regionName: properties['NAME'] ?? '',
      total: properties['$currentLayerAffix-COUNT'] ?? 0,
      averageDown: properties['$currentLayerAffix-DOWNLOAD'] ?? 0,
      averageUp: properties['$currentLayerAffix-UPLOAD'] ?? 0,
      averageLatency: properties['$currentLayerAffix-PING'] ?? 0,
    );
  }

  void onIspMnoSwitch(bool? isIspActive) {
    if (isIspActive == null) {
      return;
    }
    emit(state.copyWith(
      isIspActive: isIspActive,
      technologies: isIspActive ? ispTechnologies : mnoTechnologies,
      currentTechnologyIndex: 0,
      currentProviderIndex: 0,
    ));
    loadProviders(isIspActive: isIspActive);
  }

  @override
  Future close() async {
    _debounce?.cancel();
    super.close();
  }
}
