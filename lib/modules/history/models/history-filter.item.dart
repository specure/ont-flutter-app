// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class HistoryFilterItem with EquatableMixin {
  final String text;
  bool active;

  HistoryFilterItem({
    required this.text,
    this.active = false,
  });

  @override
  List<Object?> get props => [text];
}
