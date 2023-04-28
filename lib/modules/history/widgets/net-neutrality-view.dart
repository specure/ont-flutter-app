import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/history-net-neutrality-item-container.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/no-results.view.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-home/net-neutrality-home.screen.dart';

import '../../../core/constants/api-errors.dart';

class NetNeutralityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return ConditionalContent(
          conditional: (!state.loading &&
              state.netNeutralityHistory?.isEmpty == true &&
              (state.errorMessage == ApiErrors.historyNotAccessible ||
                  state.errorMessage == null)),
          truthyBuilder: () {
            return NoResultsView(
              title: 'No results to show.',
              linkText: 'Make your first measurement',
              onTap: () => GetIt.I
                  .get<CoreCubit>()
                  .goToScreen<NetNeutralityHomeScreen>(),
            );
          },
          falsyBuilder: () {
            return Column(
              children: [
                SizedBox(height: 8),
                NetNeutralityHistoryHeader(),
                Expanded(
                  child: ConditionalContent(
                    conditional: !state.loading,
                    truthyBuilder: () => LazyLoadScrollView(
                      onEndOfPage: () =>
                          context.read<HistoryCubit>().onEndOfSpeedPage(),
                      child: ListView.builder(
                        itemCount: state.netNeutralityHistory?.length,
                        itemBuilder: (context, index) =>
                            HistoryNetNeutralityItemContainerWidget(
                          item: state.netNeutralityHistory![index],
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
    );
  }
}

class NetNeutralitySection extends StatelessWidget {
  final FlexFit flexFit = FlexFit.tight;
  final String header;

  NetNeutralitySection({required this.header});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 4,
      fit: flexFit,
      child: Text(
        header.translated,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: NTDimensions.textXXXS,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NetNeutralityHistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 46,
            child: Container(),
          ),
          NetNeutralitySection(header: NetNeutralityType.DNS),
          NetNeutralitySection(header: NetNeutralityType.WEB),
          // TODO: uncomment when another NN test will be done and lover flex by 4 for each test in flexible above
          // NetNeutralitySection(header: NetNeutralityType.UDP),
          // NetNeutralitySection(header: NetNeutralityType.TCP),
          // NetNeutralitySection(header: NetNeutralityType.VOP),
          // NetNeutralitySection(header: NetNeutralityType.UNM),
          // NetNeutralitySection(header: NetNeutralityType.TSP),
          // NetNeutralitySection(header: NetNeutralityType.TCR),
        ],
      ),
    );
  }
}
