import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/primary.button.dart';
import 'package:nt_flutter_standalone/core/widgets/result-screen-title.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/advanced-results.screen.dart';

import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

class MeasurementResultLandscapeConfig extends MeasurementResultConfig {
  MeasurementResultLandscapeConfig(MeasurementHistoryResult? result)
      : super(result: result);

  @override
  Widget buildBasicMetadataSection() {
    return Column(children: [
      _buildRowSection([
        TextSection(
          title: 'Date & Time',
          value: result?.measurementDate != null
              ? DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.parse(result?.measurementDate ?? '').toLocal())
              : '-',
        ),
        TextSection(
          title: 'Phone information',
          value: result?.device ?? '-',
        ),
        TextSection(
          title: 'Network type',
          value: result?.resolveNetworkInfo() ?? "-",
          icon: result?.networkType == 'WLAN' || result?.networkType == wifi
              ? Icons.signal_wifi_4_bar
              : Icons.signal_cellular_alt_outlined,
        ),
        TextSection(
          title: 'Network name',
          value: result?.operator ?? '-',
        )
      ]),
      SizedBox(height: 32)
    ]);
  }

  @override
  Widget buildDownloadSection() {
    return _Section(
      sectionTitle: "Download",
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ResultScreenTitle(
                value: result?.downloadSpeedMbpsFormatted ?? "-",
                units: result?.downloadSpeedMbpsFormatted != null ? "Mbps" : "",
              ),
            ),
            _buildAdvancedButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedButton() {
    return PrimaryButton(
      title: 'Switch to Advanced Results'.translated,
      onPressed: () => GetIt.I
          .get<NavigationService>()
          .pushNamed(AdvancedResultsScreen.route),
      width: 255,
    );
  }

  Widget _buildRowSection(List<TextSection> subsections) {
    return Row(
      children: List.generate(
        subsections.length,
        (index) => Expanded(child: subsections[index]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String sectionTitle;
  final Widget child;

  const _Section({required this.sectionTitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SectionTitle(sectionTitle), child],
    );
  }
}
