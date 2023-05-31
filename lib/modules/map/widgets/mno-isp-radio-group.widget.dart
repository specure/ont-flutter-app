import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

class MnoIspRadioGroup extends StatelessWidget {
  const MnoIspRadioGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (mapContext, mapState) {
      return Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                GetIt.I.get<MapCubit>().onIspMnoSwitch(false);
              },
              child: ListTile(
                title: Text(
                  'Mobile Network Operators',
                  style: TextStyle(fontSize: NTDimensions.textS),
                ),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                horizontalTitleGap: 0,
                leading: Radio<bool>(
                  value: false,
                  groupValue: mapState.isIspActive,
                  onChanged: (bool? value) {
                    GetIt.I.get<MapCubit>().onIspMnoSwitch(value);
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                GetIt.I.get<MapCubit>().onIspMnoSwitch(true);
              },
              child: ListTile(
                title: Text(
                  'Fixed-Line Providers',
                  style: TextStyle(fontSize: NTDimensions.textS),
                ),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                horizontalTitleGap: 0,
                leading: Radio<bool>(
                  value: true,
                  groupValue: mapState.isIspActive,
                  onChanged: (bool? value) {
                    GetIt.I.get<MapCubit>().onIspMnoSwitch(value);
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
