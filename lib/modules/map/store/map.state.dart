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
    var currentTechnologies = technologies ?? this.technologies;
    var technologyIndex = currentTechnologyIndex ?? this.currentTechnologyIndex;
    technologyIndex = _ensureIsInRange(technologyIndex, currentTechnologies.length - 1);
    var currentProviders = providers ?? this.providers;
    var providerIndex = currentProviderIndex ?? this.currentProviderIndex;
    providerIndex = _ensureIsInRange(providerIndex, currentProviders.length - 1);
    return MapState(
      providers: providers ?? this.providers,
      technologies: technologies ?? this.technologies,
      isIspActive: isIspActive ?? this.isIspActive,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      isTechnologyBarExpanded:
          isTechnologyBarExpanded ?? this.isTechnologyBarExpanded,
      searchResults: searchResults ?? this.searchResults,
      currentTechnologyIndex: technologyIndex,
      currentProviderIndex: providerIndex,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      currentPeriodPickerYearIndex:
          currentPeriodPickerYearIndex ?? this.currentPeriodPickerYearIndex,
      currentPeriodPickerMonthIndex:
          currentPeriodPickerMonthIndex ?? this.currentPeriodPickerMonthIndex,
      defaultPeriod: defaultPeriod ?? this.defaultPeriod,
    );
  }

  int _ensureIsInRange(int index, maxIndex) {
    return index < 0 || index > maxIndex ? 0 : index;
  }
}
