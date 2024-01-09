import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/api-errors.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/screens/filters.screen.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/net-neutrality-view.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/speed-view/speed.view.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/no-results.view.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/settings.screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    GetIt.I.get<HistoryCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          previous.errorMessage != current.errorMessage &&
          current.speedHistory.isNotEmpty,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(NTErrorSnackbar(state.errorMessage!)),
      bloc: GetIt.I.get<HistoryCubit>(),
      builder: (context, state) => DefaultTabController(
        length: getTabs().length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: NTAppBar(
            color: Colors.white,
            titleText: 'Results',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: ConditionalContent(
                conditional:
                    _getFromState(context, state).runtimeType == TabBarView,
                truthyBuilder: () => Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        labelColor: NTColors.primary,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: NTColors.primary,
                        tabs: getTabs(),
                      ),
                    ),
                    ConditionalContent(
                        conditional: (state.deviceFilters.isNotEmpty ||
                            state.networkTypeFilters.isNotEmpty),
                        truthyBuilder: () {
                          return IconButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              HistoryFiltersScreen.route,
                            ),
                            icon: Icon(Icons.filter_list),
                          );
                        }),
                    ConditionalContent(
                      conditional: state.enableSynchronization == true,
                      truthyBuilder: () {
                        return IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.devices),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(child: _getFromState(context, state)),
        ),
      ),
    );
  }

  Widget _getFromState(BuildContext context, HistoryState state) {
    if (!state.isHistoryEnabled) {
      return NoResultsView(
        title: '#appName needs certain permissions to operate correctly.'
            .translated
            .replaceAll(
              '#appName',
              Environment.appName,
            ),
        linkText: 'Go to the privacy permissions',
        onTap: () => GetIt.I.get<CoreCubit>().goToScreen<SettingsScreen>(),
      );
    }
    if (!state.loading &&
        state.speedHistory.isEmpty &&
        state.errorMessage != null &&
        state.errorMessage != ApiErrors.historyNotAccessible) {
      return NTErrorWidget(state.errorMessage!);
    }
    return TabBarView(
      children: getTabBarViews(),
    );
  }

  List<Tab> getTabs() {
    var tabs = [Tab(text: 'Speed'.translated)];
    if (GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.netNeutralityTestsEnabled) ==
        true) {
      tabs.add(Tab(text: 'Net Neutrality'.translated));
    }
    return tabs;
  }

  List<Widget> getTabBarViews() {
    List<Widget> tabBarViews = [HistorySpeedView()];
    if (GetIt.I
            .get<SharedPreferencesWrapper>()
            .getBool(StorageKeys.netNeutralityTestsEnabled) ==
        true) {
      tabBarViews.add(NetNeutralityView());
    }
    return tabBarViews;
  }
}
