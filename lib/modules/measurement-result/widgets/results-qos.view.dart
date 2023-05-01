import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/signal-strength.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/technology-signal.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/network-speed-section.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/result-bottom-sheet.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/technology-over-time.chart.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/text-section.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/server-network-types.dart';

class ResultsQosView extends StatelessWidget {
  const ResultsQosView();

  static const double horizontalPadding = 28;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementResultCubit, MeasurementResultState>(
      builder: (context, state) {
        final result = state.result;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Flexible(
                            child: NetworkSpeedSection(
                              title: 'Download',
                              speed:
                                  result?.downloadSpeedMbpsFormatted ?? unknown,
                              speedList: result?.downloadSpeedDetails ?? [],
                            ),
                          ),
                          SizedBox(width: 32),
                          Flexible(
                            child: NetworkSpeedSection(
                              title: 'Upload',
                              speed:
                                  result?.uploadSpeedMbpsFormatted ?? unknown,
                              speedList: result?.uploadSpeedDetails ?? [],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextSection(
                              title: 'Ping',
                              value:
                                  result?.pingMs.toInt().toString() ?? unknown,
                              valueUnit: 'ms',
                            ),
                          ),
                          ConditionalContent(
                            conditional:
                                state.project?.enableAppJitterAndPacketLoss ==
                                    true,
                            truthyBuilder: () {
                              return Flexible(
                                child: TextSection(
                                  title: 'Jitter',
                                  value: result?.jitterMs?.toInt().toString() ??
                                      unknown,
                                  valueUnit: 'ms',
                                ),
                              );
                            },
                          ),
                          ConditionalContent(
                            conditional:
                                state.project?.enableAppJitterAndPacketLoss ==
                                    true,
                            truthyBuilder: () {
                              return Flexible(
                                child: TextSection(
                                  title: 'Packet loss',
                                  value:
                                      result?.packetLossPercents?.toString() ??
                                          unknown,
                                  valueUnit: '%',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      _buildSignalAndQualitySection(result?.radioSignals ?? []),
                      TechnologyOverTimeChart(
                        signals: (result?.radioSignals?.length == 1
                                ? (result!.radioSignals! + result.radioSignals!)
                                : result?.radioSignals) ??
                            [],
                        chartWidth: MediaQuery.of(context).size.width -
                            (horizontalPadding * 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConditionalContent(
                conditional:
                    state.project?.enableAppQosResultExplanation == true,
                truthyBuilder: () => ElevatedButton(
                      onPressed: () {
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
                          builder: (context) => ResultBottomSheet(
                            context,
                            state,
                            pageUrl: NTUrls.cmsMethodologyQosRoute,
                            pageContent: "qos explanation".translated,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 32,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Learn more about Quality of Service".translated,
                              style: TextStyle(color: NTColors.primary),
                            )),
                            Icon(
                              Icons.info_outline,
                              color: NTColors.primary,
                            )
                          ],
                        ),
                      ),
                    )),
          ],
        );
      },
    );
  }

  Widget _buildSignalAndQualitySection(List<TechnologySignal> signals) {
    final PlatformWrapper platform = GetIt.I.get<PlatformWrapper>();
    return ConditionalContent(
      conditional: platform.isAndroid && signals.isNotEmpty,
      truthyBuilder: () {
        int lastSignal = signals.last.signal.toInt();
        final lastTechnology = signals.last.technology;
        return Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextSection(
                    title: 'Signal',
                    value: lastSignal == 0 ? '-' : lastSignal.toString(),
                    valueUnit: 'dBm',
                    largeValueFont: true,
                  ),
                ),
                SizedBox(width: 32),
                Expanded(
                  child: TextSection(
                    title: 'Quality',
                    value: lastSignal == 0
                        ? '-'
                        : getSignalQuality(lastTechnology, lastSignal),
                    valueUnit: '',
                    largeValueFont: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
