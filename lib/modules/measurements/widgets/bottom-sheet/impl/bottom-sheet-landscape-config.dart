import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/permission-dialog.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/bottom-sheet-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/ip-info.widget.dart';

class BottomSheetLandscapeConfig extends BottomSheetConfig {
  BottomSheetLandscapeConfig(MeasurementsState state, BuildContext context)
      : super(state: state, context: context);

  @override
  final Axis mainAxis = Axis.horizontal;

  @override
  Widget getContent() {
    var problem = "";
    if (state.locationServicesEnabled == false) {
      problem = 'Location services disabled';
    } else if (state.permissions.preciseLocationPermissionsGranted == false) {
      problem = 'Missing permissions';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConditionalContent(
            conditional: GetIt.I.get<PlatformWrapper>().isAndroid &&
                (state.permissions.preciseLocationPermissionsGranted == false ||
                    state.locationServicesEnabled == false),
            truthyBuilder: () => PermissionDialog(
              locationServicesEnabled: state.locationServicesEnabled,
              preciseLocationPermissionsGranted:
                  state.permissions.preciseLocationPermissionsGranted,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.warning,
                          color: Colors.yellow,
                        ),
                      ),
                      Text(
                        problem,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            falsyBuilder: () => Container(
              width: 0,
              height: 0,
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildNetworkTypeName(),
                        buildPaddingDivider(),
                      ])),
              SizedBox(
                width: 56,
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 56),
                          child: ConditionalContent(
                            conditional:
                                GetIt.I.get<CoreCubit>().state.currentScreen ==
                                    0,
                            truthyBuilder: () => Container(
                              height: 50,
                              child: MeasurementServer(
                                measurementServerName: state.currentServerName,
                              ),
                            ),
                            falsyBuilder: () => buildLocation(),
                          ),
                        ),
                        buildPaddingDivider(),
                      ])),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 56),
                          child: IPInfo(
                            state: state,
                            badgeText: 'IPv4',
                            statusColor:
                                state.networkInfoDetails.ipV4StatusColor,
                            publicAddress:
                                state.networkInfoDetails.ipV4PublicAddress,
                            privateAddress:
                                state.networkInfoDetails.ipV4PrivateAddress,
                          ),
                        ),
                        buildPaddingDivider(),
                      ])),
              SizedBox(
                width: 56,
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 56),
                          child: IPInfo(
                            state: state,
                            badgeText: 'IPv6',
                            direction: Axis.vertical,
                            statusColor:
                                state.networkInfoDetails.ipV6StatusColor,
                            publicAddress:
                                state.networkInfoDetails.ipV6PublicAddress,
                            privateAddress:
                                state.networkInfoDetails.ipV6PrivateAddress,
                          ),
                        ),
                        buildPaddingDivider(),
                      ]))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [buildSignal()])),
              SizedBox(
                width: 56,
              ),
              ConditionalContent(
                conditional: GetIt.I.get<CoreCubit>().state.currentScreen == 0,
                truthyBuilder: () => Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildLocation(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
