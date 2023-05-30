import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/modules/map/models/technology.item.dart';

class MapState {
  final List<String> providers;
  final List<TechnologyItem> technologies;
  final bool isIspActive;
  final bool isSearchActive;
  final bool isTechnologyBarExpanded;
  final List<MapSearchItem>? searchResults;
  final int currentTechnologyIndex;
  final int currentProviderIndex;
  final DateTime? currentPeriod;
  final int currentPeriodPickerYearIndex;
  final int currentPeriodPickerMonthIndex;
  final DateTime? defaultPeriod;

  MapState({
    required this.providers,
    required this.technologies,
    this.isIspActive = false,
    this.isSearchActive = false,
    this.isTechnologyBarExpanded = false,
    this.searchResults,
    this.currentTechnologyIndex = 0,
    this.currentProviderIndex = 0,
    this.currentPeriod,
    this.currentPeriodPickerYearIndex = 0,
    this.currentPeriodPickerMonthIndex = 0,
    this.defaultPeriod,
  });

  MapState copyWith({
    List<String>? providers,
    List<TechnologyItem>? technologies,
    bool? isIspActive,
    bool? isSearchActive,
    bool? isTechnologyBarExpanded,
    List<MapSearchItem>? searchResults,
    int? currentTechnologyIndex,
    int? currentProviderIndex,
    DateTime? currentPeriod,
    int? currentPeriodPickerYearIndex,
    int? currentPeriodPickerMonthIndex,
    DateTime? defaultPeriod,
  }) {
    return MapState(
      providers: providers ?? this.providers,
      technologies: technologies ?? this.technologies,
      isIspActive: isIspActive ?? this.isIspActive,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      isTechnologyBarExpanded:
          isTechnologyBarExpanded ?? this.isTechnologyBarExpanded,
      searchResults: searchResults ?? this.searchResults,
      currentTechnologyIndex:
          currentTechnologyIndex ?? this.currentTechnologyIndex,
      currentProviderIndex: currentProviderIndex ?? this.currentProviderIndex,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      currentPeriodPickerYearIndex:
          currentPeriodPickerYearIndex ?? this.currentPeriodPickerYearIndex,
      currentPeriodPickerMonthIndex:
          currentPeriodPickerMonthIndex ?? this.currentPeriodPickerMonthIndex,
      defaultPeriod: defaultPeriod ?? this.defaultPeriod,
    );
  }
}
