import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/loop-mode.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/primary.button.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/services/loop.mode.service.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:nt_flutter_standalone/modules/settings/widgets/settings-editable-item.dart';
import 'package:sprintf/sprintf.dart';

class LoopModeSettingsScreen extends StatefulWidget {
  static const route = 'settings/loopModeSettings';

  const LoopModeSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LoopModeSettingsScreen> createState() => _LoopModeSettingsScreenState();
}

class _LoopModeSettingsScreenState extends State<LoopModeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          current.errorMessage != previous.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(NTErrorSnackbar(state.errorMessage!));
      },
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: NTAppBar(
          height: 48,
          color: Colors.white,
          titleText: 'Loop mode'.translated,
          actions: [
            IconButton(
              onPressed: () {
                GetIt.I.get<SettingsCubit>().clearUiErrors();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: NTColors.primary),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 64),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildHeader(context, state),
                    ThinDivider(),
                    _buildWaitingTime(context, state),
                    ThinDivider(),
                    _buildDistance(context, state),
                    ThinDivider(),
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
                        style: TextStyle(
                          fontSize: NTDimensions.textM,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(height: 1, color: Colors.black26),
                    _buildButtons(context, state),
                    ThinDivider(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isValueValid(String? text, int minValue, int maxValue) {
    if (text != null) {
      final value = int.tryParse(text);
      return (value != null && value <= maxValue && value >= minValue);
    } else {
      return false;
    }
  }

  _onValidationSucceeded(LoopModeCheckedFieldType fieldType, int value) {
    GetIt.I.get<SettingsCubit>().onValidationSucceeded(fieldType, value);
  }

  _onValidationError(LoopModeCheckedFieldType fieldType) {
    GetIt.I.get<SettingsCubit>().onValidationFailed(fieldType);
  }

  _showErrorMessage(
      int minValue, int maxValue, LoopModeCheckedFieldType fieldType) {
    GetIt.I.get<SettingsCubit>().process(Exception(sprintf(
        "Please insert value between %d and %d.".translated,
        [minValue, maxValue])));
    _onValidationError(fieldType);
  }

  Widget _buildHeader(BuildContext context, SettingsState state) {
    return Container(
      height: 152,
      child: Column(
        children: [
          Text(
            'Number of measurements'.translated,
            style: TextStyle(
              fontSize: NTDimensions.textL,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 75,
              child: TextFormField(
                key: Key('lmc'),
                decoration: InputDecoration(
                  helperText: " ",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                validator: (value) {
                  if (_isValueValid(
                    value,
                    LoopMode.loopModeMeasurementCountMin,
                    LoopMode.loopModeMeasurementCountMax,
                  )) {
                    if (value != null) {
                      _onValidationSucceeded(
                        LoopModeCheckedFieldType.LOOP_MODE_COUNT,
                        int.tryParse(value) ??
                            LoopMode.loopModeDefaultMeasurementCount,
                      );
                    }
                    return null;
                  } else {
                    _onValidationError(
                        LoopModeCheckedFieldType.LOOP_MODE_COUNT);
                    return "";
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (text) {
                  if (_isValueValid(
                    text,
                    LoopMode.loopModeMeasurementCountMin,
                    LoopMode.loopModeMeasurementCountMax,
                  )) {
                    GetIt.I
                        .get<SettingsCubit>()
                        .onLoopModeMeasurementCountChange(int.tryParse(text));
                  } else {
                    _showErrorMessage(
                      LoopMode.loopModeMeasurementCountMin,
                      LoopMode.loopModeMeasurementCountMax,
                      LoopModeCheckedFieldType.LOOP_MODE_COUNT,
                    );
                  }
                },
                initialValue: state.loopModeTestCountSet.toString(),
                autofocus: true,
                style: TextStyle(
                  fontSize: NTDimensions.title,
                  color: Colors.black,
                  height: 1.7,
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
            bottom: 32,
          )),
        ],
      ),
    );
  }

  Widget _buildWaitingTime(BuildContext context, SettingsState state) {
    return SettingsEditableItem(
      key: Key("lmwt"),
      title: 'Waiting time (minutes)',
      subtitle: sprintf(
        'Between %d min - %d mins'.translated,
        [
          LoopMode.loopModeWaitingTimeMinutesMin,
          LoopMode.loopModeWaitingTimeMinutesMax,
        ],
      ),
      value: state.loopModeWaitingTimeMinSet.toString(),
      onFieldSubmitted: (text) {
        if (_isValueValid(
          text,
          LoopMode.loopModeWaitingTimeMinutesMin,
          LoopMode.loopModeWaitingTimeMinutesMax,
        )) {
          GetIt.I
              .get<SettingsCubit>()
              .onLoopModeWaitingTimeChange(int.tryParse(text));
        } else {
          _showErrorMessage(
            LoopMode.loopModeWaitingTimeMinutesMin,
            LoopMode.loopModeWaitingTimeMinutesMax,
            LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME,
          );
        }
      },
      validator: (value) {
        if (_isValueValid(
          value,
          LoopMode.loopModeWaitingTimeMinutesMin,
          LoopMode.loopModeWaitingTimeMinutesMax,
        )) {
          if (value != null) {
            _onValidationSucceeded(
              LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME,
              int.tryParse(value) ?? LoopMode.loopModeDefaultWaitingTimeMinutes,
            );
          }
          return null;
        } else {
          _onValidationError(
            LoopModeCheckedFieldType.LOOP_MODE_WAITING_TIME,
          );
          return "";
        }
      },
    );
  }

  Widget _buildDistance(BuildContext context, SettingsState state) {
    return SettingsEditableItem(
      key: Key("lmd"),
      title: 'Distance (meters)',
      value: state.loopModeDistanceMetersSet.toString(),
      onFieldSubmitted: (text) {
        if (_isValueValid(
          text,
          LoopMode.loopModeDistanceMetersMin,
          LoopMode.loopModeDistanceMetersMax,
        )) {
          GetIt.I.get<SettingsCubit>().onLoopModeDistanceMetersChange(
                int.tryParse(text),
              );
        } else {
          _showErrorMessage(
            LoopMode.loopModeDistanceMetersMin,
            LoopMode.loopModeDistanceMetersMax,
            LoopModeCheckedFieldType.LOOP_MODE_DISTANCE,
          );
        }
      },
      validator: (value) {
        if (_isValueValid(
          value,
          LoopMode.loopModeDistanceMetersMin,
          LoopMode.loopModeDistanceMetersMax,
        )) {
          if (value != null) {
            _onValidationSucceeded(
              LoopModeCheckedFieldType.LOOP_MODE_DISTANCE,
              int.tryParse(value) ?? LoopMode.loopModeDefaultDistanceMeters,
            );
          }
          return null;
        } else {
          _onValidationError(
            LoopModeCheckedFieldType.LOOP_MODE_DISTANCE,
          );
          return "";
        }
      },
    );
  }

  Widget _buildButtons(BuildContext context, SettingsState state) {
    return Container(
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryButton(
            title: "Start test".translated,
            onPressed: () {
              // TODO: replace by starting measurement screen with loop mode running when ready
              GetIt.I.get<SettingsCubit>().clearUiErrors();
              GetIt.I.get<LoopModeService>().setShouldLoopModeStart(true);
              Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.route));
            },
            width: 200,
            enabled: state.isLoopModeConfiguredCorrectly(),
          ),
        ),
      ]),
    );
  }
}
