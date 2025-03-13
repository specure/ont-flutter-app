import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/header-with-logo.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-hero-image.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/test-is-impossible.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.config.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';

class NetNeutralityHomePortraitConfig extends NetNeutralityHomeConfig {
  NetNeutralityHomePortraitConfig({required NetNeutralityState state})
      : super(state: state);

  @override
  Widget get content => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        final state = GetIt.I.get<CoreCubit>().state;
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: HeaderWithLogo(),
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
                              state.connectivity != ConnectivityResult.none,
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
                                        child: runButton,
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
