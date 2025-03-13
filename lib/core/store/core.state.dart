import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';

class CoreState extends Equatable {
  final int currentScreen;
  final bool netNeutralityTestsEnabled;
  final ConnectivityResult? connectivity;
  final NTProject? project;
  final String? clientUuid;

  CoreState({
    this.connectivity,
    this.currentScreen = 0,
    this.netNeutralityTestsEnabled = false,
    this.project,
    this.clientUuid,
  });

  CoreState copyWith({
    int? currentScreen,
    bool? netNeutralityTestsEnabled,
    ConnectivityResult? connectivity,
    NTProject? project,
    String? clientUuid,
  }) =>
      CoreState(
        connectivity: connectivity ?? this.connectivity,
        currentScreen: currentScreen ?? this.currentScreen,
        netNeutralityTestsEnabled:
            netNeutralityTestsEnabled ?? this.netNeutralityTestsEnabled,
        project: project ?? this.project,
        clientUuid: clientUuid ?? this.clientUuid,
      );

  @override
  List<Object?> get props => [
        connectivity,
        currentScreen,
        netNeutralityTestsEnabled,
        project,
        clientUuid,
      ];
}
