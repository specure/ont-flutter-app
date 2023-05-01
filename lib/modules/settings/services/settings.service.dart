import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/settings.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';

class SettingsService extends DioService {
  final SharedPreferencesWrapper _preferences =
      GetIt.I.get<SharedPreferencesWrapper>();

  SettingsService({bool testing = false}) : super(testing: testing);

  Future<String?> saveClientUuidAndSettings(
      {ErrorHandler? errorHandler}) async {
    final bool persistentClientUuid =
        _preferences.getBool(StorageKeys.persistentClientUuidEnabled) ?? true;
    String? clientUuid =
        persistentClientUuid ? await _preferences.clientUuid : null;
    clientUuid = await setSettings(
      Settings(uuid: clientUuid, termsAndConditionsAccepted: true),
      errorHandler: errorHandler,
    );
    if (persistentClientUuid && clientUuid != null) {
      await _preferences.setString(StorageKeys.clientUuid, clientUuid);
    }
    return clientUuid;
  }

  Future<String?> setSettings(Settings settings,
      {ErrorHandler? errorHandler}) async {
    var data = settings.toJson();
    data.removeWhere((key, value) => value == null);
    try {
      var response = await dio.post(NTUrls.csSettingsRoute, data: data);
      return response.data['settings'][0]['uuid'];
    } on DioError catch (e) {
      print(e);
      errorHandler?.process(e);
      return null;
    }
  }
}
