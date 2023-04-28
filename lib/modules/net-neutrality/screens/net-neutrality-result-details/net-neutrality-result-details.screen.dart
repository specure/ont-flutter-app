import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/models/net-neutrality-history-item.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-result-detail-item-container.dart';

class NetNeutralityResultDetailScreen extends StatelessWidget {
  static const route = 'net-neutrality/result/details';

  const NetNeutralityResultDetailScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
      builder: (context, state) => Scaffold(
        appBar: NTAppBar(
          actions: [],
          leading: IconButton(
            onPressed: () => GetIt.I.get<NavigationService>().goBack(),
            icon: Icon(Icons.arrow_back, color: NTColors.primary),
          ),
          titleText: state.resultDetailsConfig?.title.translated,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SectionTitle("Information".translated),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                      state.resultDetailsConfig?.information.translated ?? ""),
                ),
                HistoryHeader(
                    columnTitles: state.resultDetailsConfig?.columnTexts ?? [],
                    columnWeights:
                        state.resultDetailsConfig?.columnWeights ?? []),
                Expanded(
                    child: ConditionalContent(
                  conditional: state.resultDetailsItems != null &&
                      state.resultDetailsItems?.isNotEmpty == true,
                  truthyBuilder: () {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.resultDetailsItems?.length,
                      itemBuilder: (context, index) {
                        final NetNeutralityHistoryItem category =
                            state.resultDetailsItems![index];
                        return NetNeutralityTestItemContainerWidget(
                            item: category);
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryHeader extends StatelessWidget {
  final List<String> columnTitles;
  final List<int> columnWeights;

  HistoryHeader({required this.columnTitles, required this.columnWeights});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildColumnTitles()),
    );
  }

  List<Widget> _buildColumnTitles() {
    if (columnTitles.length != columnWeights.length) {
      throw Exception(
          "Titles size and weights size are not equal for building the header");
    }
    List<Widget> headers = [];
    for (int i = 0; i < columnTitles.length; i++) {
      final title = columnTitles[i];
      final weight = columnWeights[i];
      headers.add(
        Flexible(
          flex: weight,
          fit: FlexFit.tight,
          child: Text(
            title.translated.toUpperCase(),
            textAlign: i == 0 ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              fontSize: NTDimensions.textXXS,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return headers;
  }
}
