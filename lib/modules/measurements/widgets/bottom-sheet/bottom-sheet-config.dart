import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/signal-info.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/servers.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/section.widget.dart';

abstract class BottomSheetConfig {
  BottomSheetConfig({required this.state, required this.context});

  late final BuildContext context;
  late final MeasurementsState state;
  final Axis mainAxis = Axis.vertical;

  Widget getContent();

  Section buildLocation() {
    return Section(
      titles: ['Location'.translated],
      values: [
        [state.currentLocation?.locationString ?? '-'],
      ],
    );
  }

  Section buildNetworkTypeName() {
    return Section(
      titles: ['Network type'.translated, 'Service provider'.translated],
      values: [
        [
          state.connectivity != ConnectivityResult.none
              ? state.networkInfoDetails.resolveNetworkName()
              : "-",
          state.connectivity != ConnectivityResult.none
              ? state.networkInfoDetails.name
              : "-"
        ],
      ],
      icons: state.connectivity != ConnectivityResult.none
          ? [
              Icon(state.networkInfoDetails.type == wifi
                  ? Icons.signal_wifi_4_bar
                  : Icons.signal_cellular_alt),
            ]
          : [],
    );
  }

  Widget buildPaddingDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ThinDivider(),
    );
  }

  ConditionalContent buildSignal() {
    return ConditionalContent(
      conditional: state.networkInfoDetails.currentAllSignalInfo.isNotEmpty &&
          state.connectivity != ConnectivityResult.none,
      truthyBuilder: () =>
          _buildSignalSection(state.networkInfoDetails.currentAllSignalInfo),
    );
  }

  Widget _buildSignalSection(List<SignalInfo> signalDetails) {
    return Column(
      children: [
        Section(
          titles: [
            'Signal'.translated,
            'Band'.translated,
            'Technology'.translated
          ],
          widths: [2, 3, 2],
          values: signalDetails
              .map((item) => [
                    item.signal == null ? '' : '${item.signal} dBm',
                    item.band == null
                        ? ''
                        : '${(item.band)} MHz' +
                            (item.isPrimaryCell == true
                                ? ' (${"Primary".translated})'
                                : ''),
                    item.technology!,
                  ])
              .toList(),
        ),
      ],
    );
  }
}

class MeasurementServer extends StatelessWidget {
  final String measurementServerName;

  const MeasurementServer({Key? key, required this.measurementServerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ServersScreen.route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: NTDimensions.textL,
            margin: EdgeInsets.only(bottom: 14),
            child: Section(
              titles: ['Measurement Server'.translated],
              values: [],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  measurementServerName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: NTDimensions.textS,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Change Test Server'.translated,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: NTColors.primary,
                      fontSize: NTDimensions.textS,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
