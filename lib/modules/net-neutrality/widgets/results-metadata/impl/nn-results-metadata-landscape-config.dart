import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/nn-results-metadata-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

class NetNeutralityResultsMetadataLandscapeConfig
    extends NetNeutralityResultsMetadataConfig {
  NetNeutralityResultsMetadataLandscapeConfig(NetNeutralityState state)
      : super(state: state);

  @override
  Widget getContent(bool navFinished) =>
      LayoutBuilder(builder: (context, viewportConstraints) {
        NetNeutralityHistoryItem? measurement =
            state.historyResults.length > 0 ? state.historyResults.first : null;
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
                        value: measurement?.device ?? unknown,
                      ),
                      TextSection(
                        title: 'Network type',
                        value: measurement?.resolveNetworkInfo() ?? "",
                        icon: measurement?.networkType == 'WLAN' ||
                                measurement?.networkType == wifi
                            ? Icons.signal_wifi_4_bar
                            : Icons.signal_cellular_alt_outlined,
                      ),
                      TextSection(
                        title: 'Network name',
                        value: measurement?.operator ?? '-',
                      ),
                    ]),
                    SizedBox(height: 40),
                    _buildRowSection([
                      TextSection(
                        title: 'Location',
                        value: measurement?.location?.locationString ?? '-',
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
