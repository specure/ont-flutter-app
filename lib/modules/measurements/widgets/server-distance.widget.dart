import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';

class ServerDistance extends StatelessWidget {
  const ServerDistance({
    Key? key,
    required this.server,
  }) : super(key: key);

  final MeasurementServer server;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 20),
      child: Text(
        server.formattedDistance,
        style: TextStyle(
          fontSize: NTDimensions.textXS,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
