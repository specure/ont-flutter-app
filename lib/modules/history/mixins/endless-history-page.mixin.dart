import 'package:nt_flutter_standalone/core/models/error-handler.dart';

mixin EndlessHistoryPage<T> {
  int _pageNumber = 1;
  ErrorHandler? errorHandler;
  List<String> activeNetworkTypeFilters = [];
  List<String> activeDeviceFilters = [];

  int get pageNumber => _pageNumber;

  bool get isFiltersActive =>
      activeNetworkTypeFilters.isNotEmpty || activeDeviceFilters.isNotEmpty;

  Future<T?> getHistory({bool resetPage = false}) async {
    onBeforeLoad();
    if (resetPage) {
      _pageNumber = 1;
    }
    return load(_pageNumber);
  }

  void onBeforeLoad() {
    throw "Not implemented";
  }

  Future<T?> load(int pageNumber) {
    throw "Not implemented";
  }

  Future<void> onEndOfPage() async {
    _pageNumber++;
    var history = await getHistory();
    if (history == null) {
      _pageNumber--;
      return;
    }
    return updateHistory(history);
  }

  void updateHistory(T? history) async {
    throw "Not implemented";
  }
}
