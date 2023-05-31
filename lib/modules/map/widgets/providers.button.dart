import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

class ProvidersButton extends StatelessWidget {
  final List<String> operators;
  final int currentOperatorIndex;
  final Function onTap;

  ProvidersButton({
    required this.operators,
    required this.currentOperatorIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return InkWell(
        onTap: () => onTap.call(),
        child: Container(
          height: 32,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          margin: EdgeInsetsDirectional.only(
            top: NTDimensions.textL,
            bottom: NTDimensions.textL,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: Colors.black.withOpacity(0.05),
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currentOperatorIndex == 0
                      ? _allProvidersTitle(state.isIspActive)
                      : operators[currentOperatorIndex],
                  style: TextStyle(
                    fontSize: NTDimensions.textS,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    });
  }

  _allProvidersTitle(bool isIspActive) => isIspActive
      ? 'All Fixed-Line Providers'.translated
      : 'All Mobile Network Operators'.translated;
}
