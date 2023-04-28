import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/permission-dialog.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/bottom-sheet-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets***REMOVED***-info.widget.dart';

class BottomSheetPortraitConfig extends BottomSheetConfig {
  BottomSheetPortraitConfig(MeasurementsState state, BuildContext context)
      : super(state: state, context: context);

  @override
  final Axis mainAxis = Axis.vertical;

  @override
  Widget getContent() {
    var problem = "";
    if (state.locationServicesEnabled == false) {
      problem = 'Location services disabled';
    } else if (state.permissions.preciseLocationPermissionsGranted == false) {
      problem = 'Missing permissions';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConditionalContent(
          conditional: GetIt.I.get<PlatformWrapper>().isAndroid &&
              (state.permissions.preciseLocationPermissionsGranted == false ||
                  state.locationServicesEnabled == false),
          truthyBuilder: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: PermissionDialog(
              locationServicesEnabled: state.locationServicesEnabled,
              preciseLocationPermissionsGranted:
                  state.permissions.preciseLocationPermissionsGranted,
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
        buildNetworkTypeName(),
        buildPaddingDivider(),
        IPInfo(
          state: state,
          badgeText: 'IPv4',
          statusColor: state.networkInfoDetails.ipV4StatusColor,
          publicAddress: state.networkInfoDetails.ipV4PublicAddress,
          privateAddress: state.networkInfoDetails.ipV4PrivateAddress,
        ),
        buildPaddingDivider(),
        IPInfo(
          state: state,
          badgeText: 'IPv6',
          direction: Axis.vertical,
          statusColor: state.networkInfoDetails.ipV6StatusColor,
          publicAddress: state.networkInfoDetails.ipV6PublicAddress,
          privateAddress: state.networkInfoDetails.ipV6PrivateAddress,
        ),
        buildPaddingDivider(),
        buildSignal(),
        buildLocation(),
        buildPaddingDivider(),
      ],
    );
  }

  @override
  ConditionalContent buildSignal() {
    return ConditionalContent(
        conditional: state.networkInfoDetails.currentAllSignalInfo.isNotEmpty,
        truthyBuilder: () =>
            Column(children: [super.buildSignal(), buildPaddingDivider()]));
  }
}
