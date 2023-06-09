import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/basic.bottom-sheet.dart';
import 'package:nt_flutter_standalone/core/widgets/divider.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

const double _providerContainerHeight = 60;

class ProvidersBottomSheet extends StatelessWidget {
  final List<String> providers;
  final Function(String) onProviderTap;

  ProvidersBottomSheet({
    required this.providers,
    required this.onProviderTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: BasicBottomSheet(
          headerTitle: _title(state.isIspActive),
          height: 60 +
              MediaQuery.of(context).padding.bottom +
              (_providerContainerHeight * providers.length),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: providers.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                    onProviderTap.call(providers[index]);
                  },
                  child: Container(
                    height: _providerContainerHeight,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(providers[index]),
                  ),
                ),
                ThinDivider(),
              ],
            ),
          ),
        ),
      );
    });
  }

  _title(bool isIspActive) => isIspActive
      ? 'Fixed-Line Providers'.translated
      : 'Mobile Network Operators'.translated;
}
