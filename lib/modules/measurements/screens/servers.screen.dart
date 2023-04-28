import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-server.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/server-checkmark.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/server-distance.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/server-name-with-city.widget.dart';

class ServersScreen extends StatelessWidget {
  static const route = 'measurements/servers';
  static final closeButtonKey = UniqueKey();

  const ServersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: NTAppBar(
        titleText: "Measurement Server",
        actions: [
          IconButton(
            key: closeButtonKey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: NTColors.primary,
            ),
          ),
        ],
      ),
      body: BlocBuilder<MeasurementsBloc, MeasurementsState>(
          builder: (context, state) => ListView.builder(
              itemCount: state.servers?.length ?? 0,
              itemBuilder: (context, index) {
                final server = state.servers?[index];
                return ConditionalContent(
                  conditional: server != null,
                  truthyBuilder: () => _Server(server: server!),
                );
              })),
    );
  }
}

class _Server extends StatelessWidget {
  const _Server({
    Key? key,
    required this.server,
  }) : super(key: key);

  final MeasurementServer server;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GetIt.I.get<MeasurementsBloc>().add(SetCurrentServer(server));
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 26, 22),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: NTColors.lightBackground,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ServerDistance(server: server),
              ServerNameWithCity(server: server),
              ServerCheckMark(server: server),
            ],
          ),
        ),
      ),
    );
  }
}
