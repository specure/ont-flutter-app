import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class PeriodBadge extends StatelessWidget {
  final DateTime currentPeriod;
  final Function() onBadgeTap;

  PeriodBadge({
    required this.currentPeriod,
    required this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onBadgeTap(),
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
        child: Text(
          '${DateFormat('MMMM').format(currentPeriod).translated} ${DateFormat('yyyy').format(currentPeriod)}',
        ),
      ),
    );
  }
}
