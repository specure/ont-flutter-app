class ApiErrors {
  static const String historyNotAccessible =
      'The history of your measurements is not accessible.';
  static const String noInternetConnection =
      'No Internet connection. Could not load data.';
  static const String internalServerError = "Internal server error.";
  static const String noConnectionToMS =
      "No connection to the measurement server. Could not load data.";
  static const String pingFailed = "Ping failed";

  ApiErrors._();
}
