import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/results-metadata-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

class ResultsMetadataLandscapeConfig extends ResultsMetadataConfig {
  ResultsMetadataLandscapeConfig(MeasurementResultState state)
      : super(state: state);

  @override
  Widget getContent(bool navFinished) =>
      LayoutBuilder(builder: (context, viewportConstraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LearnMoreButton(title: "Want to learn more ***REMOVED*** Metadata?"),
                    SizedBox(height: 40),
                    _buildRowSection([
                      TextSection(
                        title: 'Date & Time',
                        value: this.getDateTime(),
                      ),
                      TextSection(
                        title: 'Phone information',
                        value: state.result?.device ?? unknown,
                      ),
                      TextSection(
                        title: 'Network type',
                        value: state.result?.resolveNetworkInfo() ?? "",
                        icon: state.result?.networkType == 'WLAN' ||
                                state.result?.networkType == wifi
                            ? Icons.signal_wifi_4_bar
                            : Icons.signal_cellular_alt_outlined,
                      ),
                      TextSection(
                        title: 'Network name',
                        value: state.result?.operator ?? '-',
                      ),
                    ]),
                    SizedBox(height: 40),
                    _buildRowSection([
                      TextSection(
                        title: 'Measurement Server',
                        value: state.result?.measurementServerName ?? '-',
                      ),
                      TextSection(
                        title: 'Location',
                        value: state.result?.location?.locationString ?? '-',
                      ),
                    ]),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      });

  Widget _buildRowSection(List<TextSection> subsections) {
    return Row(
        children: List.generate(
      subsections.length,
      (index) => Expanded(child: subsections[index]),
    ));
  }
}
