import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';

class ServerNameWithCity extends StatelessWidget {
  const ServerNameWithCity({
    Key? key,
    required this.server,
  }) : super(key: key);

  final MeasurementServer server;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          server.nameWithCity,
          style: TextStyle(fontSize: NTDimensions.textM),
        ),
      ),
    );
  }
}
