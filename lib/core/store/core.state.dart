import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

class CoreState extends Equatable {
  final int currentScreen;
  final bool netNeutralityTestsEnabled;
  final ConnectivityResult? connectivity;

  CoreState({
    this.connectivity,
    this.currentScreen = 0,
    this.netNeutralityTestsEnabled = false,
  });

  CoreState copyWith({
    int? currentScreen,
    bool? netNeutralityTestsEnabled,
    ConnectivityResult? connectivity,
  }) =>
      CoreState(
        connectivity: connectivity ?? this.connectivity,
        currentScreen: currentScreen ?? this.currentScreen,
        netNeutralityTestsEnabled:
            netNeutralityTestsEnabled ?? this.netNeutralityTestsEnabled,
      );

  @override
  List<Object?> get props => [
        connectivity,
        currentScreen,
        netNeutralityTestsEnabled,
      ];
}
