import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/widgets/basic.bottom-sheet.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/map/models/measurements.data.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class MeasurementsPopup extends StatelessWidget {
  final MeasurementsData data;

  MeasurementsPopup(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: BasicBottomSheet(
        headerTitle: 'Measurements',
        height: MediaQuery.of(context).padding.bottom +
            (data.regionType.isNotEmpty ? 360 : 300),
        child: SingleChildScrollView(
              child: Column(
                children: [
                  ConditionalContent(
                    conditional: data.regionType.isNotEmpty,
                    truthyBuilder: () => Column(
                      children: [
                        _buildMeasurementTile(data.regionType, data.regionName),
                        ThinDivider(),
                      ],
                    ),
                  ),
                  _buildMeasurementTile(
                    'Total Measurements',
                    data.total.round().toString(),
                  ),
                  ThinDivider(),
                  _buildMeasurementTile(
                    'Average Down',
                    '${data.averageDown.round().toString()} Mbps',
                  ),
                  ThinDivider(),
                  _buildMeasurementTile(
                    'Average Up',
                    '${data.averageUp.round().toString()} Mbps',
                  ),
                  ThinDivider(),
                  _buildMeasurementTile(
                    'Average Ping',
                    '${data.averageLatency.round().toString()} ms',
                  ),
                ],
              ),
            )

      ),
    );
  }

  Widget _buildMeasurementTile(String title, String value) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.translated,
            style: TextStyle(color: Colors.black54),
          ),
          Text(value.translated),
        ],
      ),
    );
  }
}
