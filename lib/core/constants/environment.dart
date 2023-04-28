import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const appName =
      String.fromEnvironment('DEFINE_APP_NAME', defaultValue: 'Open Nettest');
  static const _appSuffix =
      String.fromEnvironment('DEFINE_APP_SUFFIX', defaultValue: ".nt");
  static String get appSuffix => '.${_appSuffix.split('.')[1]}';
  static const controlServerUrl = String.fromEnvironment(
    'DEFINE_CONTROL_SERVER_URL',
    defaultValue: 'api-dev.nettest.org',
  );
  static const cmsServerUrl = String.fromEnvironment(
    'DEFINE_CMS_SERVER_URL',
    defaultValue: 'portal-api-dev.nettest.org',
  );
  static const webpageUrl = String.fromEnvironment(
    'DEFINE_WEBPAGE_URL',
    defaultValue: 'dev.nettest.com',
  );
  static final configPath = dotenv.env['CONFIG_PATH'];

  Environment._();
}
