import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.state.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/net-neutrality-tests-results.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/widgets/results-metadata/nn-results-metadata.view.dart';

class NetNeutralityResultScreen extends StatefulWidget {
  static const route = 'net-neutrality/result';

  const NetNeutralityResultScreen({Key? key}) : super(key: key);

  @override
  State<NetNeutralityResultScreen> createState() =>
      _NetNeutralityResultScreenState();
}

class _NetNeutralityResultScreenState extends State<NetNeutralityResultScreen> {
  bool _navFinished = false;
  int _childrenCount = 2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetNeutralityCubit, NetNeutralityState>(
        builder: (context, state) => WillPopScope(
            onWillPop: () =>
                GetIt.I.get<NetNeutralityCubit>().stopMeasurement(),
            child: DefaultTabController(
              length: _childrenCount,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: NTAppBar(
                  color: Colors.white,
                  actions: [],
                  leading: IconButton(
                    onPressed: () =>
                        GetIt.I.get<NetNeutralityCubit>().stopMeasurement(),
                    icon: Icon(Icons.arrow_back, color: NTColors.primary),
                    color: NTColors.primary,
                  ),
                  titleText: 'Net neutrality results'.translated,
                  bottom: TabBar(
                    labelColor: NTColors.primary,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: NTColors.primary,
                    tabs: [
                      Tab(text: 'Tests'),
                      Tab(text: 'Metadata'),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Builder(builder: (context) {
                    final controller = DefaultTabController.of(context);
                    controller.addListener(
                      () {
                        setState(() {
                          if (controller.indexIsChanging == false &&
                              controller.index == (_childrenCount - 1)) {
                            _navFinished = true;
                          } else {
                            _navFinished = false;
                          }
                        });
                      },
                    );
                    return TabBarView(
                      children: [
                        const NetNeutralityTestsResults(),
                        NetNeutralityResultsMetadataView(
                            navFinished: _navFinished),
                      ],
                    );
                  }),
                ),
              ),
            )));
  }
}
