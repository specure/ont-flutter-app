import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/history-speed-item/history-speed-item.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/no-results.view.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/speed-view/impl/speed-view-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/speed-view/impl/speed-view-portrait-config.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/speed-view/speed-view-config.dart';
import 'package:nt_flutter_standalone/modules/measurements/widgets/start-test/start-test.widget.dart';

class HistorySpeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NTOrientationBuilder<SpeedViewConfig>(
        portraitConfig: SpeedViewPortraitConfig(),
        landscapeConfig: SpeedViewLandscapeConfig(),
        builder: (config) => BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                return ConditionalContent(
                  conditional: (!state.loading &&
                      state.speedHistory.isEmpty &&
                      (state.errorMessage == ApiErrors.historyNotAccessible ||
                          state.errorMessage == null)),
                  truthyBuilder: () {
                    return NoResultsView(
                      title: 'No results to show.',
                      linkText: 'Make your first measurement',
                      onTap: () => GetIt.I
                          .get<CoreCubit>()
                          .goToScreen<StartTestWidget>(),
                    );
                  },
                  falsyBuilder: () {
                    return Column(
                      children: [
                        SizedBox(height: 8),
                        HistoryHeader(flexFit: config.flexFit),
                        Expanded(
                          child: ConditionalContent(
                            conditional: !state.loading,
                            truthyBuilder: () => LazyLoadScrollView(
                              onEndOfPage: () => context
                                  .read<HistoryCubit>()
                                  .onEndOfSpeedPage(),
                              child: ListView.builder(
                                itemCount: state.speedHistory.length,
                                itemBuilder: (context, index) =>
                                    HistorySpeedItemWidget(
                                  item: state.speedHistory[index],
                                ),
                              ),
                            ),
                            falsyBuilder: () => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: NTColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ));
  }
}

class HistoryHeader extends StatelessWidget {
  final FlexFit flexFit;

  HistoryHeader({required this.flexFit});

  @override
  Widget build(BuildContext context) {
    var paramWidth = 55.0;
    var paramSmallWidth = 36.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            fit: flexFit,
            child: Container(
              width: paramWidth,
              child: Text(
                'Download (Mbps)'.translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: NTDimensions.textXXXS,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: flexFit,
            child: Container(
              width: paramWidth,
              child: Text(
                'Upload (Mbps)'.translated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: NTDimensions.textXXXS,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: flexFit,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Container(
                width: paramSmallWidth,
                child: Text(
                  'Ping (ms)'.translated,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: NTDimensions.textXXXS,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
