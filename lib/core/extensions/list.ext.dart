import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;

extension ListUtils<T extends double> on List<T> {
  double get median {
    final copy = [...this]..sort((a, b) => (a - b).toInt());
    final middle = copy.length ~/ 2;
    return copy.length % 2 == 0
        ? (copy[middle - 1] + copy[middle]) / 2
        : copy[middle];
  }
}

extension ConnectvityListUtils on List<ConnectivityResult> {
  ConnectivityResult get wifiOrMobile {
    var result = firstWhere((c) => c == ConnectivityResult.wifi,
        orElse: () => ConnectivityResult.none);
    if (result == ConnectivityResult.none) {
      result = firstWhere((c) => c == ConnectivityResult.mobile,
          orElse: () => ConnectivityResult.none);
    }
    return result;
  }
}
