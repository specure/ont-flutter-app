import 'package:equatable/equatable.dart';

class LoopMedian with EquatableMixin {
  List<double> values;
  double? medianValue;

  LoopMedian({
    required this.values,
    required this.medianValue
  });

  @override
  List<Object?> get props => [
    this.values,
    this.medianValue,
  ];
}