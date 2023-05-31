import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

class PeriodBadge extends StatelessWidget {
  PeriodBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return GestureDetector(
        onTap: () => GetIt.I.get<MapCubit>().onPeriodBadgeTap(),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: ConditionalContent(
              conditional: state.currentPeriod != null,
              truthyBuilder: () {
                return Text(
                  '${DateFormat('MMMM').format(state.currentPeriod!).translated} ${DateFormat('yyyy').format(state.currentPeriod!)}',
                );
              }),
        ),
      );
    });
  }
}
