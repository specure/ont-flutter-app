import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/mixins/error-handling-state.mixin.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.events.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/impl/start-test-lanscape-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/impl/start-test-portrait-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test-config.dart';

class StartTestWidget extends StatefulWidget {
  @override
  State<StartTestWidget> createState() => _StartTestWidgetState();

  didPop() {
    final bloc = GetIt.I.get<MeasurementsBloc>();
    if (bloc.state.connectivity == ConnectivityResult.none) {
      bloc.add(Initialize());
    } else {
      bloc.add(CheckIfLoopModeShouldStart());
    }
  }
}

class _StartTestWidgetState extends State<StartTestWidget>
    with RouteAware, ErrorHandlingState {
  bool isDialogShown = false;
  final _bloc = GetIt.I.get<MeasurementsBloc>();
  late StreamSubscription<MeasurementsState> _continuationSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _continuationSub = GetIt.I
        .get<MeasurementsBloc>()
        .stream
        .distinct((a, b) => a.isContinuing == b.isContinuing)
        .listen(_openMeasurementScreen);
    GetIt.I.get<RouteObserver>().subscribe(this, ModalRoute.of(context)!);
    if (_bloc.state.connectivity == ConnectivityResult.none ||
        _bloc.state.connectivity == null) {
      _bloc.add(Initialize());
    }
  }

  @override
  void dispose() {
    _continuationSub.cancel();
    GetIt.I.get<RouteObserver>().unsubscribe(this);
    _bloc.add(HomeScreenLeft());
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPop();
    widget.didPop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeasurementsBloc, MeasurementsState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) => handleError(
        context,
        state,
        setState: setState,
        onRetry: () {
          GetIt.I.get<MeasurementsBloc>().add(RestartMeasurement());
          GetIt.I.get<NavigationService>().goBack();
        },
        onFinish: () {
          GetIt.I.get<MeasurementsBloc>().add(StopMeasurement());
          GetIt.I.get<NavigationService>().goBack();
        },
      ),
      builder: (context, state) => NTOrientationBuilder<StartTestConfig>(
        portraitConfig: StartTestPortraitConfig(state),
        landscapeConfig: StartTestLandscapeConfig(state),
        builder: (config) => Scaffold(
          appBar: NTAppBar(height: 0),
          body: config.content,
        ),
      ),
    );
  }

  _openMeasurementScreen(MeasurementsState state) {
    if (state.isContinuing &&
        !state.isMeasurementScreenOpen &&
        state.phase != MeasurementPhase.none) {
      try {
        Navigator.pushNamed(context, MeasurementScreen.route);
        GetIt.I.get<MeasurementsBloc>().add(SetMeasurmentScreenOpen(true));
      } catch (_) {}
    }
  }
}
