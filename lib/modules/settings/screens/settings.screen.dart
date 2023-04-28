import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/languages.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-settings.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:nt_flutter_standalone/modules/settings/widgets/settings-item.dart';
import 'package:sprintf/sprintf.dart';

import '../../../core/services/navigation.service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>()..init(),
      builder: (context, state) => Scaffold(
        backgroundColor: NTColors.lightBackground,
        appBar: NTAppBar(
          height: 48,
          color: Colors.white,
          titleText: 'Settings',
        ),
        body: ListView(
          padding: EdgeInsets.only(bottom: 16),
          children: [
            ..._buildLanguageSection(context, state),
            ..._buildInformationSection(context, state),
            // TODO: for general section..._buildGeneralSection(context, state),
            ...(_buildLoopModeSection(context, state) as Column).children,
            ..._buildPrivacySection(context, state),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInformationSection(
      BuildContext context, SettingsState state) {
    return [
      _SectionLabel('Information'),
      SettingsItem(
        title: '${'About'.translated} ${Environment.appName}',
        onTap: () => GetIt.I.get<SettingsCubit>().getPage(
              NTUrls.cmsAboutRoute,
              '${'About'.translated} ${Environment.appName}',
            ),
      ),
      ThinDivider(),
      SettingsItem(
        title: 'Terms of service',
        onTap: () => GetIt.I.get<SettingsCubit>().getPage(
              NTUrls.cmsTermsOfUseRoute,
              'Terms of service',
            ),
      ),
      ThinDivider(),
      SettingsItem(
        title: 'Version',
        value: state.appVersion,
        showArrow: false,
      ),
    ];
  }

  // TODO: for general section
  // List<Widget> _buildGeneralSection(BuildContext context, SettingsState state) {
  //   return [
  //     _SectionLabel('General'),
  //     SettingsItem(
  //       title: 'Net Neutrality Measurements',
  //       showArrow: true,
  //       value: state.netNeutralityMeasurement.toName(),
  //     ),
  //   ];
  // }

  Widget? _buildLoopModeSection(BuildContext context, SettingsState state) {
    return ConditionalContent(
      conditional: state.loopModeFeatureEnabled,
      truthyBuilder: () => Column(
        children: [
          ..._buildLoopModeSettings(context, state),
          Padding(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              top: 20,
              bottom: 8,
            ),
            child: Text(
              'When loop mode is enabled, new tests are automatically performed after the configured waiting time or when the devices moves more than the configured distance.'
                  .translated,
              style: TextStyle(fontSize: NTDimensions.textM),
            ),
          ),
        ],
      ),
      falsyBuilder: () => Column(children: [Container()]),
    ).build(context);
  }

  List<Widget> _buildLoopModeSettings(
      BuildContext context, SettingsState state) {
    return [
      _SectionLabel('Loop mode'),
      SettingsItem(
        title: 'Loop mode',
        showArrow: false,
        onTap: () => handleLoopModeActivation(!state.loopModeEnabled, state),
        onSwitchChange: (bool) => {handleLoopModeActivation(bool, state)},
        switchEnabled: state.loopModeEnabled ? 1 : 0,
      ),
      ConditionalContent(
          conditional: state.loopModeEnabled,
          truthyBuilder: () => Column(children: [
                ThinDivider(),
                SettingsItem(
                  title: 'Number of measurements',
                  value: state.loopModeTestCountSet.toString(),
                  showArrow: false,
                  onTap: () => handleLoopModeSettingsTap(context),
                ),
                ThinDivider(),
                SettingsItem(
                  title: 'Waiting time (minutes)',
                  value: state.loopModeWaitingTimeMinSet.toString(),
                  subtitle: sprintf('Between %d min - %d mins'.translated, [
                    LoopMode.loopModeWaitingTimeMinutesMin,
                    LoopMode.loopModeWaitingTimeMinutesMax
                  ]),
                  showArrow: false,
                  onTap: () => handleLoopModeSettingsTap(context),
                ),
                ThinDivider(),
                SettingsItem(
                  title: 'Distance (meters)',
                  value: state.loopModeDistanceMetersSet.toString(),
                  showArrow: false,
                  onTap: () => handleLoopModeSettingsTap(context),
                ),
                ThinDivider(),
                // todo: removed until we do not have implementation for net neutrality tests
                // SettingsItem(
                //   title: 'Include Net Neutrality',
                //   showArrow: false,
                //   onSwitchChange: context
                //       .read<SettingsCubit>()
                //       .onLoopModeNetNeutralityChange,
                //   switchEnabled: state.loopModeNetNeutralityEnabled ? 1 : 0,
                // ),
              ]))
    ];
  }

  List<Widget> _buildPrivacySection(BuildContext context, SettingsState state) {
    return [
      _SectionLabel('Privacy'),
      SettingsItem(
        title: 'Client UUID',
        subtitle: state.clientUuid ?? unknown,
        showArrow: false,
      ),
      ThinDivider(),
      SettingsItem(
          title: 'Persistent client UUID',
          subtitle:
              'Persistent client UUID is needed to enable measurement history and synchronisation of the results between devices',
          showArrow: false,
          onSwitchChange:
              context.read<SettingsCubit>().onPersistentClientUuidChange,
          switchEnabled: state.persistentClientUuidEnabled ? 1 : 0,
          switchKey: 'persistentClientSwitch'),
      ThinDivider(),
      SettingsItem(
        title: 'Privacy policy',
        onTap: () => GetIt.I.get<SettingsCubit>().getPage(
              NTUrls.cmsPrivacyPolicyRoute,
              'Privacy policy',
            ),
      ),
      //TODO: Implement analytics
      // ThinDivider(),
      // SettingsItem(
      //   title: 'Analytics',
      //   subtitle: 'Enable analytics and send crash traces to us',
      //   showArrow: false,
      //   switchEnabled: 0,
      // ),
    ];
  }

  List<Widget> _buildLanguageSection(
      BuildContext context, SettingsState state) {
    if (state.languageSwitchEnabled) {
      return [
        _SectionLabel('Language'),
        SettingsItem(
            title: 'Selected language',
            subtitle: state.selectedLanguage?.nativeName ?? 'Default',
            showArrow: true,
            onTap: () => GetIt.I
                .get<NavigationService>()
                .pushNamed(LanguagesScreen.route)),
        ThinDivider(),
      ];
    } else {
      return [];
    }
  }

  handleLoopModeSettingsTap(BuildContext context) {
    Navigator.pushNamed(context, LoopModeSettingsScreen.route);
  }

  handleLoopModeActivation(bool loopModeEnabling, SettingsState state) {
    if (loopModeEnabling) {
      GetIt.I.get<SettingsCubit>().openLoopModeAgreement();
    } else {
      GetIt.I.get<SettingsCubit>().onLoopModeEnabledChange(false);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
          top: 26,
          bottom: 8,
        ),
        child: Text(
          text.translated.toUpperCase(),
          style: TextStyle(fontSize: NTDimensions.textM),
        ),
      ),
    );
  }
}
