import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

abstract class NetNeutralityResultsMetadataConfig {
  NetNeutralityResultsMetadataConfig({required this.state});

  late final NetNeutralityState state;

  Widget getContent(bool navFinished);

  getDateTime() {
    try {
      final result =
          state.historyResults.length > 0 ? state.historyResults.first : null;
      return DateFormat('dd.MM.yyyy HH:mm')
          .format(DateTime.parse(result?.measurementDate ?? '').toLocal());
    } catch (ex) {
      return "-";
    }
  }
}
