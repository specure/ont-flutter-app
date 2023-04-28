import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/servers.screen.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

class ServerInfo extends StatelessWidget {
  const ServerInfo({Key? key, required this.state, required this.direction})
      : super(key: key);

  final Axis direction;
  final MeasurementsState state;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Text('Measurement Server'.translated),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ServersScreen.route);
              },
              child: Text(
                state.currentServerName,
                style: TextStyle(color: NTColors.primary),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
