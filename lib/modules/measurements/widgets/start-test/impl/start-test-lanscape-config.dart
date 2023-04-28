import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
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

class StartTestLandscapeConfig extends StartTestConfig {
  StartTestLandscapeConfig(MeasurementsState state) : super(state: state);

  @override
  final Axis measurementServerMainAxis = Axis.horizontal;

  @override
  Widget get content => LayoutBuilder(builder: (context, viewportConstraints) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 28,
                left: 16,
                right: 0,
                child: HeaderWithLogo(
                  additionalButtons: [loopModeButton],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 76, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: HomeHeroImage(
                        state: state,
                        imagePath: state.connectivity !=
                                    ConnectivityResult.none &&
                                state.currentServer == null
                            ? 'config/${Environment.appSuffix}/images/home-screen-hero-no-server.svg'
                            : null,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: ConditionalContent(
                        conditional:
                            state.connectivity != ConnectivityResult.none,
                        truthyBuilder: () {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConditionalContent(
                                conditional: state.connectivity !=
                                    ConnectivityResult.none,
                                truthyBuilder: () {
                                  return HomeInfoBox();
                                },
                              ),
                              ConditionalContent(
                                conditional: state.connectivity !=
                                        ConnectivityResult.none &&
                                    state.currentServer != null,
                                truthyBuilder: () {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Stack(
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
                                  );
                                },
                              ),
                              ConditionalContent(
                                conditional: state.currentServer != null,
                                truthyBuilder: () {
                                  return ServerInfo(
                                    state: state,
                                    direction: measurementServerMainAxis,
                                  );
                                },
                                falsyBuilder: () {
                                  return TestIsImpossible(
                                    message: "No Measurement Server",
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        falsyBuilder: () {
                          return TestIsImpossible();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
