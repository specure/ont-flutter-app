import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.state.dart';
import 'package:nt_flutter_standalone/modules/history/widgets/filter-item.dart';

class HistoryFiltersScreen extends StatelessWidget {
  static const route = 'history/filters';

  const HistoryFiltersScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      bloc: GetIt.I.get<HistoryCubit>(),
      builder: (context, state) => Scaffold(
        backgroundColor: NTColors.lightBackground,
        appBar: NTAppBar(
          height: 52,
          color: Colors.white,
          titleText: 'Filter',
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: NTColors.primary,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 26,
                  bottom: 10,
                  left: 20,
                ),
                child: SectionTitle('Network type'),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.networkTypeFilters.length,
                itemBuilder: (context, index) => FilterItem(
                  item: state.networkTypeFilters[index],
                  isLast: index == (state.networkTypeFilters.length - 1),
                  onTap: (filter) =>
                      GetIt.I.get<HistoryCubit>().onFilterTap(filter),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 26,
                  bottom: 10,
                  left: 20,
                ),
                child: SectionTitle('Device'),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.deviceFilters.length,
                itemBuilder: (context, index) => FilterItem(
                  item: state.deviceFilters[index],
                  isLast: index == (state.deviceFilters.length - 1),
                  onTap: (filter) =>
                      GetIt.I.get<HistoryCubit>().onFilterTap(filter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
