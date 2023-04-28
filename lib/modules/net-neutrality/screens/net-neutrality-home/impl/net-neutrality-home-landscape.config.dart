import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/header-with-logo.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-hero-image.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/test-is-impossible.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

class NetNeutralityHomeLandscapeConfig extends NetNeutralityHomeConfig {
  NetNeutralityHomeLandscapeConfig({required NetNeutralityState state})
      : super(state: state);

  @override
  Widget get content => LayoutBuilder(builder: (context, viewportConstraints) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 28,
                left: 16,
                right: 0,
                child: HeaderWithLogo(),
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
                              HomeInfoBox(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: runButton,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        falsyBuilder: () => TestIsImpossible(),
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
