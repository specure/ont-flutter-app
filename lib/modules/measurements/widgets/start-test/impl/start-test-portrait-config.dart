import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/header-with-logo.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/loop-mode-badge.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-hero-image.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test-button.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/test-is-impossible.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/server-info.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test-config.dart';

class StartTestPortraitConfig extends StartTestConfig {
  StartTestPortraitConfig(MeasurementsState state) : super(state: state);

  @override
  final Axis measurementServerMainAxis = Axis.vertical;

  @override
  Widget get content => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: HeaderWithLogo(
                  additionalButtons: [loopModeButton],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: viewportConstraints.maxHeight - 78,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      ConditionalContent(
                        conditional:
                            state.connectivity == ConnectivityResult.none,
                        truthyBuilder: () => Flexible(
                          fit: FlexFit.loose,
                          child: TestIsImpossible(),
                        ),
                      ),
                      ConditionalContent(
                        conditional:
                            state.connectivity == ConnectivityResult.none,
                        truthyBuilder: () => Flexible(
                          child: Center(
                            child: HomeHeroImage(),
                          ),
                        ),
                      ),
                      ConditionalContent(
                        conditional:
                            state.connectivity != ConnectivityResult.none &&
                                state.currentServer == null,
                        truthyBuilder: () => Flexible(
                          fit: FlexFit.loose,
                          child: TestIsImpossible(
                            message: "No Measurement Server",
                          ),
                        ),
                      ),
                      ConditionalContent(
                        conditional:
                            state.connectivity != ConnectivityResult.none &&
                                state.currentServer == null,
                        truthyBuilder: () => Flexible(
                          child: Center(
                            child: HomeHeroImage(
                              imagePath:
                                  'config/${Environment.appSuffix}/images/home-screen-hero-no-server.svg',
                            ),
                          ),
                        ),
                      ),
                      ConditionalContent(
                          conditional:
                              state.connectivity != ConnectivityResult.none &&
                                  state.currentServer != null,
                          truthyBuilder: () {
                            return Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Spacer(flex: 4),
                                  Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const StartTestButton(),
                                      ),
                                      ConditionalContent(
                                        conditional: !state.isInitializing &&
                                            !state.isContinuing,
                                        truthyBuilder: () => LoopModeBadge(),
                                        falsyBuilder: () => SizedBox(
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: HomeHeroImage(),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: ServerInfo(
                                      state: state,
                                      direction: measurementServerMainAxis,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                ],
                              ),
                            );
                          }),
                      ConditionalContent(
                        conditional:
                            state.connectivity != ConnectivityResult.none,
                        truthyBuilder: () {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(child: HomeInfoBox()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
}
