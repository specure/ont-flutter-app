import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatefulWidget {
  final Widget child;
  final bool locationServicesEnabled;
  final bool preciseLocationPermissionsGranted;

  PermissionDialog({
    required this.child,
    this.locationServicesEnabled = true,
    this.preciseLocationPermissionsGranted = true});

  @override
  State<PermissionDialog> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.locationServicesEnabled == false) {
            _showProblemResolvingDialog(
                'Location services disabled',
                "We need enabled location services in order to provide more accurate information ***REMOVED*** your network connection.",
                AppSettings.openLocationSettings);
          } else if (widget.preciseLocationPermissionsGranted == false) {
            _showProblemResolvingDialog(
                'Missing permissions',
                "We need permission to access the precise location in order to provide more accurate information ***REMOVED*** your network connection.",
                openAppSettings);
          }
        },
        child: this.widget.child);
  }

  Future<void> _showProblemResolvingDialog(
      String title, String text, Function() action) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.translated),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text.translated),
              ],
            ),
          ),
          actions: <Widget>[
            GradientButton(
              colors: [Colors.transparent],
              child: Text(
                "Change settings".translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NTColors.primary,
                  fontSize: NTDimensions.textM,
                ),
              ),
              onPressed: () {
                GetIt.I.get<NavigationService>().goBack();
                action();
              },
              height: 84 * MediaQuery.of(context).textScaleFactor,
              width: 170 * MediaQuery.of(context).textScaleFactor,
            ),
            GradientButton(
              colors: [Colors.transparent],
              child: Text(
                "Cancel".translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NTColors.primary,
                  fontSize: NTDimensions.textM,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                GetIt.I.get<NavigationService>().goBack();
              },
              height: 84 * MediaQuery.of(context).textScaleFactor,
              width: 92 * MediaQuery.of(context).textScaleFactor,
            )
          ],
        );
      },
    );
  }
}
