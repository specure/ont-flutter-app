import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/primary.button.dart';
import 'package:nt_flutter_standalone/core/widgets/secondary.button.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-settings.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:nt_flutter_standalone/modules/settings/widgets/check-item.dart';
import 'package:nt_flutter_standalone/modules/settings/widgets/explanation-item.dart';
import 'package:sprintf/sprintf.dart';

class LoopModeAgreementScreen extends StatelessWidget {
  static const route = 'settings/loopModeAgreement';

  const LoopModeAgreementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) =>
          Scaffold(
            backgroundColor: Colors.white,
            appBar: NTAppBar(
              height: 48,
              color: Colors.white,
              titleText: 'Loop mode'.translated,
              actions: [
                IconButton(
                  onPressed: () {Navigator.pop(context);},
                  icon: Icon(Icons.close, color: NTColors.primary),
                ),
              ],
            ),
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ..._buildHeader(context, state),
                    CheckItem(
                        text: 'The first test will start immediately after the loop mode has been initiated.'),
                    CheckItem(text: sprintf(
                        'Further tests will be started after either the waiting time (default %d min) has elapsed or the configured distance (default %d meters) has been covered.'.translated, [
                      LoopMode.loopModeDefaultWaitingTimeMinutes,
                      LoopMode.loopModeDefaultDistanceMeters
                    ])),
                    CheckItem(
                        text: 'Tests will be performed until the configured number of tests (default 10 tests) has been reached.'),
                    CheckItem(
                        text: 'The loop mode is automatically terminated after 2 days.'),
                    CheckItem(text: 'The loop mode can be stopped at any time.'),
                    CheckItem(text: 'These values can be changed under settings.'),
                    ExplanationItem(title: "Data usage",
                        text: "data usage explanation"),
                    ExplanationItem(title: "Battery power",
                        text: "battery power explanation")
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              _buildButtons(context, state),
            ]
          ),
    );
  }

  List<Widget> _buildHeader(BuildContext context, SettingsState state) {
    return [
      Text(
        'Activation & Privacy'.translated,
        style: TextStyle(fontSize: NTDimensions.textL),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'The loop mode allows the automatic repetition of #appName.'
              .translated
              .replaceAll(
            '#appName',
            Environment.appName,
          ),
          style: TextStyle(
              fontSize: NTDimensions.textL, color: Colors.black26, height: 1.7),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(
            bottom: 32,
          )
      ),
    ];
  }

  Widget _buildButtons(BuildContext context, SettingsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SecondaryButton(
            title: "Decline".translated,
            onPressed: () {
              Navigator.pop(context);
            },
            width: 125,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryButton(
            title: "Agree".translated,
            onPressed: () {
              GetIt.I.get<SettingsCubit>().onLoopModeEnabledChange(true);
              Navigator.popAndPushNamed(context, LoopModeSettingsScreen.route);
            },
            width: 125,
          ),
        ),
      ]
    );
  }
}