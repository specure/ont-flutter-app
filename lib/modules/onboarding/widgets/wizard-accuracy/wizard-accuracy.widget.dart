import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.state.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/welcome-message.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy-item.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/impl/wizard-accuracy-landscape.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/impl/wizard-accuracy-portrait.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/widgets/wizard-accuracy/wizard-accuracy.config.dart';

class WizardAccuracy extends StatefulWidget {
  const WizardAccuracy({
    Key? key,
  }) : super(key: key);

  @override
  State<WizardAccuracy> createState() => _WizardAccuracyState();
}

class _WizardAccuracyState extends State<WizardAccuracy> {
  bool _canContinue = false;

  @override
  Widget build(BuildContext context) {
    final WizardState state = GetIt.I.get<WizardCubit>().state;
    return NTOrientationBuilder<WizardAccuracyConfig>(
      builder: (config) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height,
          width: size.width,
          padding: config.getContainerPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.extentAfter == 0) {
                      setState(() {
                        _canContinue = true;
                      });
                    }
                    return true;
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      WelcomeMessage(
                        title: "#appName Accuracy"
                            .translated
                            .replaceAll('#appName', Environment.appName),
                        lead:
                            "#appName needs certain functionality to operate correctly."
                                .translated
                                .replaceAll("#appName", Environment.appName),
                      ),
                      ConditionalContent(
                        conditional: GetIt.I.get<PlatformWrapper>().isAndroid,
                        truthyBuilder: () => Container(
                          margin: const EdgeInsets.only(top: 26),
                          child: WizardAccuracyItem(
                            key: ValueKey('phone'),
                            iconData: Icons.call,
                            title: "Phone Permissions",
                            lead:
                                "We will never make or manage phone calls. We use phone permissions to identify the mobile operator used for testing.",
                            hasSwitch: true,
                            switchValue: state.isPhoneStatePermissionsSwitchOn,
                            onSwitchChange: (p0) {
                              GetIt.I.get<WizardCubit>().update(
                                    state.copyWith(
                                        isPhoneStatePermissionsSwitchOn: p0),
                                  );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 26),
                        child: WizardAccuracyItem(
                          key: ValueKey('location'),
                          iconData: Icons.location_pin,
                          title: "Location Permissions",
                          lead:
                              "Your location identifies nearby servers and your device's cellular connection in order to properly configure #appName"
                                  .translated
                                  .replaceAll('#appName', Environment.appName),
                          hasSwitch: true,
                          switchValue: state.isLocationPermissionsSwitchOn,
                          onSwitchChange: (p0) {
                            GetIt.I.get<WizardCubit>().update(
                                  state.copyWith(
                                      isLocationPermissionsSwitchOn: p0),
                                );
                          },
                        ),
                      ),
                      ConditionalContent(
                        conditional: GetIt.I.get<PlatformWrapper>().isIOS &&
                            state.project?.enableAppNetNeutralityTests == true,
                        truthyBuilder: () => Container(
                          margin: const EdgeInsets.only(top: 26),
                          child: WizardAccuracyItem(
                            key: ValueKey('localNetwork'),
                            iconData: Icons.travel_explore,
                            title: "Local Network Permissions",
                            lead: "NSLocalNetworkUsageDescription",
                            hasSwitch: true,
                            switchValue: state.isNetworkAccessSwitchOn,
                            onSwitchChange: (p0) {
                              GetIt.I.get<WizardCubit>().update(
                                    state.copyWith(isNetworkAccessSwitchOn: p0),
                                  );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 26),
                        child: WizardAccuracyItem(
                          key: ValueKey('clientUuid'),
                          iconData: Icons.assignment_ind,
                          title: "Persistent Client UUID",
                          lead: "Client UUID explanation text",
                          hasSwitch: true,
                          switchValue: state.isPersistentClientUuidSwitchOn,
                          onSwitchChange: (p0) {
                            GetIt.I.get<WizardCubit>().update(
                                  state.copyWith(
                                      isPersistentClientUuidSwitchOn: p0),
                                );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 26),
                        child: WizardAccuracyItem(
                          key: ValueKey('analytics'),
                          iconData: Icons.trending_up,
                          title: "Help us improve #appName"
                              .translated
                              .replaceAll('#appName', Environment.appName),
                          lead:
                              "#appName may use third party services to collect data ***REMOVED*** your device and your usage of #appName and use it to improve the application experience and stability."
                                  .translated
                                  .replaceAll('#appName', Environment.appName),
                          hasSwitch: true,
                          switchValue: state.isAnalyticsSwitchOn,
                          onSwitchChange: (p0) {
                            GetIt.I.get<WizardCubit>().update(
                                  state.copyWith(isAnalyticsSwitchOn: p0),
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: GradientButton(
                  colors: _canContinue ? null : [Colors.black26],
                  child: Text(
                    "Continue".translated,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: NTDimensions.textM,
                    ),
                  ),
                  onPressed: _canContinue
                      ? () {
                          GetIt.I.get<WizardCubit>().handlePermissions();
                        }
                      : null,
                  width: 125,
                ),
              ),
            ],
          ),
        );
      },
      portraitConfig: WizardAccuracyPortraitConfig(),
      landscapeConfig: WizardAccuracyLandscapeConfig(),
    );
  }
}
