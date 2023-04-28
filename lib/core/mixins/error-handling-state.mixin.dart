import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/gradient-button.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/measurement-error.dart';

mixin ErrorHandlingState {
  bool isDialogShown = false;

  Future<dynamic> handleError(
    BuildContext context,
    ErrorState state, {
    required Function setState,
    Function? onRetry,
    Function? onFinish,
  }) async {
    if (isDialogShown || state.errorMessage == null) {
      return;
    }
    if (!(state.error is MeasurementError)) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      return ScaffoldMessenger.of(context)
          .showSnackBar(NTErrorSnackbar(state.errorMessage!))
          .closed
          .then((value) => ScaffoldMessenger.of(context).clearSnackBars())
          .catchError((_) {});
    }
    setState(() {
      isDialogShown = true;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (BuildContext context) => AlertDialog(
        title: SectionTitle(
          "Error",
          color: NTColors.subtitle,
        ),
        content: SingleChildScrollView(
          child: Text(
            state.errorMessage!.translated,
            style: TextStyle(
              fontSize: NTDimensions.textM,
              height: 1.5,
            ),
          ),
        ),
        actions: <Widget>[
          ConditionalContent(
            conditional: state.connectivity != ConnectivityResult.none,
            truthyBuilder: () => GradientButton(
              colors: [Colors.transparent],
              child: Text(
                "Try again".translated,
                style: TextStyle(
                  color: NTColors.primary,
                  fontSize: NTDimensions.textM,
                ),
              ),
              onPressed: () {
                if (onRetry != null) {
                  onRetry();
                }
                setState(() {
                  isDialogShown = false;
                });
              },
              height: 42 * MediaQuery.of(context).textScaleFactor,
              width: 92 * MediaQuery.of(context).textScaleFactor,
            ),
          ),
          GradientButton(
            colors: [Colors.transparent],
            child: Text(
              "Finish".translated,
              style: TextStyle(
                color: NTColors.primary,
                fontSize: NTDimensions.textM,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (onFinish != null) {
                onFinish();
              }
              setState(() {
                isDialogShown = false;
              });
            },
            height: 42 * MediaQuery.of(context).textScaleFactor,
            width: 92 * MediaQuery.of(context).textScaleFactor,
          )
        ],
      ),
    );
  }
}
