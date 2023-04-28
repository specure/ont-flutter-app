import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

class ServerCheckMark extends StatelessWidget {
  const ServerCheckMark({
    Key? key,
    required this.server,
  }) : super(key: key);

  final MeasurementServer server;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) {
      return ConditionalContent(
        conditional: server.id == state.currentServer?.id,
        truthyBuilder: () => Container(
          height: 14,
          width: 18,
          margin: EdgeInsets.only(left: 26, bottom: 10, right: 7),
          child: Icon(
            Icons.check,
            color: NTColors.primary,
          ),
        ),
      );
    });
  }
}
