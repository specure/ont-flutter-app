import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';
import 'package:nt_flutter_standalone/modules/map/widgets/period-picker.list-view.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class PeriodPicker extends StatelessWidget {
  final double _listViewItemHeight = 40;
  final MapCubit cubit = GetIt.I.get<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      bloc: cubit,
      builder: (context, state) => Container(
        height: 184 + MediaQuery.of(context).padding.bottom,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Title(cubit: cubit),
            SizedBox(height: 8),
            Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: PeriodPickerListView(
                          items: cubit.periodPickerYearsList,
                          align: Alignment.centerRight,
                          itemHeight: _listViewItemHeight,
                          initialItemIndex: state.currentPeriodPickerYearIndex,
                          onItemIndexChange: (index) =>
                              cubit.onPeriodPickerYearIndexChange(index),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: PeriodPickerListView(
                          items: cubit.periodPickerMonthsList,
                          align: Alignment.centerLeft,
                          itemHeight: _listViewItemHeight,
                          initialItemIndex: state.currentPeriodPickerMonthIndex,
                          onItemIndexChange: (index) =>
                              cubit.onPeriodPickerMonthIndexChange(index),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: _listViewItemHeight),
                  color: Colors.black12,
                  height: 1,
                  width: double.infinity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final MapCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 12,
        top: 20,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'History'.translated.toUpperCase(),
              style: TextStyle(
                fontSize: NTDimensions.textS,
                color: Colors.black54,
              ),
            ),
          ),
          GestureDetector(
            child: Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
