import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../store/measurement-result.state.dart';

abstract class ResultsMetadataConfig {
  ResultsMetadataConfig({required this.state});

  late final MeasurementResultState state;

  Widget getContent(bool navFinished);

  getDateTime() {
    try {
      return DateFormat('dd.MM.yyyy HH:mm').format(
          DateTime.parse(state.result?.measurementDate ?? '').toLocal());
    } catch (ex) {
      return "-";
    }
  }
}
