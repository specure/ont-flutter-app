import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/section.widget.dart';

class IPInfo extends StatelessWidget {
  const IPInfo({
    Key? key,
    required this.state,
    required this.badgeText,
    this.statusColor = Colors.grey,
    this.publicAddress = addressIsNotAvailable,
    this.privateAddress = addressIsNotAvailable,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final MeasurementsState state;
  final String badgeText;
  final Color statusColor;
  final String publicAddress;
  final String privateAddress;
  final Axis direction;

  Color get badgeColor => state.project?.enableAppIpColorCoding != true ||
          state.connectivity == ConnectivityResult.none
      ? Colors.grey
      : statusColor;

  Color get badgeTextColor => state.project?.enableAppIpColorCoding == true &&
          (badgeColor == NetworkInfoDetails.green ||
              badgeColor == NetworkInfoDetails.yellow)
      ? Colors.black
      : Colors.white;

  Widget get _horizontalLayout {
    if (state.project?.enableAppPrivateIp == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 16),
            child: _Badge(
              color: badgeColor,
              textColor: badgeTextColor,
              text: badgeText,
            ),
          ),
          Section(
            titles: ['Private address'.translated, 'Public address'.translated],
            values: [
              [
                _getVisibleAddress(privateAddress),
                _getVisibleAddress(publicAddress),
              ]
            ],
          )
        ],
      );
    }
    return oneLineLayout;
  }

  Widget get _verticalLayout {
    if (state.project?.enableAppPrivateIp == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 16),
            child: _Badge(
              color: badgeColor,
              textColor: badgeTextColor,
              text: badgeText,
            ),
          ),
          TextSection(
            title: 'Private address'.translated,
            value: _getVisibleAddress(privateAddress),
          ),
          Container(
            height: 28,
          ),
          TextSection(
            title: 'Public address'.translated,
            value: _getVisibleAddress(publicAddress),
          ),
        ],
      );
    }
    return oneLineLayout;
  }

  Widget get oneLineLayout => Container(
        height: 20,
        child: Row(
          children: [
            _Badge(
                color: badgeColor, textColor: badgeTextColor, text: badgeText),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  _getVisibleAddress(publicAddress),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: NTDimensions.textS,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ConditionalContent(
      conditional: direction == Axis.horizontal,
      truthyBuilder: () => _horizontalLayout,
      falsyBuilder: () => _verticalLayout,
    );
  }

  String _getVisibleAddress(String address) =>
      state.connectivity != ConnectivityResult.none
          ? address.translated
          : addressIsNotAvailable.translated;
}

class _Badge extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;

  _Badge({
    required this.color,
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: NTDimensions.textS,
          color: textColor,
        ),
      ),
    );
  }
}
