import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/permission-dialog.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/permissions.service.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/bottom-sheet/bottom-sheet.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/home-info-box-item.widget.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeInfoBox extends StatefulWidget {
  const HomeInfoBox({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeInfoBox> createState() => _HomeInfoBoxState();
}

class _HomeInfoBoxState extends State<HomeInfoBox> {
  Widget _getNetworkDetails(MeasurementsState state) {
    if (state.permissions.phoneStatePermissionsGranted &&
        state.permissions.locationPermissionsGranted) {
      return _buildNetworkInfo(state);
    } else {
      return _buildPermissionsResolverInfo(state);
    }
  }

  String _showPermissionsMissingText(MeasurementsState state) {
    if (!state.permissions.locationPermissionsGranted) {
      return 'Missing location permissions';
    }
    if (!state.permissions.phoneStatePermissionsGranted) {
      return 'Missing read phone state permissions';
    }
    return '-';
  }

  Widget _buildNetworkInfo(MeasurementsState state) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeInfoBoxItem(
                key: Key('Network type box'),
                title: 'Network type',
                value:
                    state.networkInfoDetails.resolveNetworkName(shorten: true),
                icon: Icon(
                  state.networkInfoDetails.type == wifi
                      ? Icons.signal_wifi_4_bar
                      : Icons.signal_cellular_alt,
                  color: Colors.black,
                ),
              ),
              HomeInfoBoxItem(
                key: Key('Network name box'),
                title: 'Network name',
                value: state.networkInfoDetails.name,
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 0,
          child: Icon(
            Icons.more_vert,
            color: NTColors.primary,
          ),
        ),
        ConditionalContent(
          conditional: GetIt.I.get<PlatformWrapper>().isAndroid &&
              (state.permissions.preciseLocationPermissionsGranted == false ||
                  state.locationServicesEnabled == false),
          truthyBuilder: () => Positioned(
              top: 12,
              right: 24,
              child: PermissionDialog(
                locationServicesEnabled: state.locationServicesEnabled,
                preciseLocationPermissionsGranted:
                    state.permissions.preciseLocationPermissionsGranted,
                child: Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
              )),
          falsyBuilder: () => Container(
            width: 0,
            height: 0,
          ),
        )
      ],
    );
  }

  Widget _buildPermissionsResolverInfo(MeasurementsState state) {
    return Padding(
      padding: EdgeInsets.all(19.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeInfoBoxItem(
            key: Key('Permissions box'),
            title: 'Permissions not granted',
            value: _showPermissionsMissingText(state),
            icon: Icon(
              Icons.warning,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementsBloc, MeasurementsState>(
        builder: (context, state) => ElevatedButton(
            onPressed: () {
              if (!state.permissions.locationPermissionsGranted ||
                  !state.permissions.phoneStatePermissionsGranted) {
                if (GetIt.I.get<PlatformWrapper>().isIOS) {
                  GetIt.I
                      .get<PermissionsService>()
                      .isLocationPermissionGranted
                      .then((value) {
                    if (!value) {
                      openAppSettings();
                    }
                  });
                } else {
                  openAppSettings();
                }
              } else {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    isDismissible: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                    ),
                    builder: (context) => HomeBottomSheet(context, state));
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              backgroundColor: Colors.white,
            ),
            child: _getNetworkDetails(state)));
  }
}
