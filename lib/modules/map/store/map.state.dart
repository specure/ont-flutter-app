import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';

class MapState {
  final List<String> mobileNetworkOperators;
  final bool isSearchActive;
  final bool isTechnologyBarExpanded;
  final List<MapSearchItem>? searchResults;
  final int currentTechnologyIndex;
  final int currentOperatorIndex;
  final DateTime? currentPeriod;
  final int currentPeriodPickerYearIndex;
  final int currentPeriodPickerMonthIndex;
  final DateTime? defaultPeriod;

  MapState({
    required this.mobileNetworkOperators,
    this.isSearchActive = false,
    this.isTechnologyBarExpanded = false,
    this.searchResults,
    this.currentTechnologyIndex = 0,
    this.currentOperatorIndex = 0,
    this.currentPeriod,
    this.currentPeriodPickerYearIndex = 0,
    this.currentPeriodPickerMonthIndex = 0,
    this.defaultPeriod,
  });

  MapState copyWith({
    List<String>? mobileNetworkOperators,
    bool? isSearchActive,
    bool? isTechnologyBarExpanded,
    List<MapSearchItem>? searchResults,
    int? currentTechnologyIndex,
    int? currentOperatorIndex,
    DateTime? currentPeriod,
    int? currentPeriodPickerYearIndex,
    int? currentPeriodPickerMonthIndex,
    DateTime? defaultPeriod,
  }) {
    return MapState(
      mobileNetworkOperators:
          mobileNetworkOperators ?? this.mobileNetworkOperators,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      isTechnologyBarExpanded:
          isTechnologyBarExpanded ?? this.isTechnologyBarExpanded,
      searchResults: searchResults ?? this.searchResults,
      currentTechnologyIndex:
          currentTechnologyIndex ?? this.currentTechnologyIndex,
      currentOperatorIndex: currentOperatorIndex ?? this.currentOperatorIndex,
      currentPeriod: currentPeriod ?? this.currentPeriod,
      currentPeriodPickerYearIndex:
          currentPeriodPickerYearIndex ?? this.currentPeriodPickerYearIndex,
      currentPeriodPickerMonthIndex:
          currentPeriodPickerMonthIndex ?? this.currentPeriodPickerMonthIndex,
      defaultPeriod: defaultPeriod ?? this.defaultPeriod,
    );
  }
}
