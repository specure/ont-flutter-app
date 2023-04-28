import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-metadata/results-metadata.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qoe.view.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/results-qos.view.dart';

class AdvancedResultsScreen extends StatefulWidget {
  static const route = 'measurements/advanced-result';

  const AdvancedResultsScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedResultsScreen> createState() => _AdvancedResultsScreenState();
}

class _AdvancedResultsScreenState extends State<AdvancedResultsScreen> {
  bool _navFinished = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: NTAppBar(
          color: Colors.white,
          titleText: 'Advanced Results',
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: NTColors.primary,
          ),
          bottom: TabBar(
            labelColor: NTColors.primary,
            unselectedLabelColor: Colors.black,
            indicatorColor: NTColors.primary,
            tabs: [
              Tab(text: 'QoS'),
              Tab(text: 'QoE'),
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
                      controller.index == 2) {
                    _navFinished = true;
                  } else {
                    _navFinished = false;
                  }
                });
              },
            );
            return TabBarView(
              children: [
                const ResultsQosView(),
                const ResultsQoeView(),
                ResultsMetadataView(navFinished: _navFinished),
              ],
            );
          }),
        ),
      ),
    );
  }
}
