import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';

abstract class MeasurementResultConfig {
  MeasurementResultConfig({required this.result});

  late final MeasurementHistoryResult? result;

  Widget buildBasicMetadataSection();
  Widget buildDownloadSection();
}
