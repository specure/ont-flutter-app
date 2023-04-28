class MeasurementsData {
  final String regionType;
  final String regionName;
  final int total;
  final num averageDown;
  final num averageUp;
  final num averageLatency;

  MeasurementsData({
    required this.regionType,
    required this.regionName,
    required this.total,
    required this.averageDown,
    required this.averageUp,
    required this.averageLatency,
  });
}
