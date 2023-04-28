import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/models/settings.dart';

final settings = Settings(
    apiLevel: 31,
    capabilities: {
      "classification": {"count": 4}
    },
    device: "Google Pixel 5",
    language: "no",
    model: "Pixel 5 5G",
    osVersion: "12",
    product: "pixel55g",
    softwareRevision: "4.0.0",
    softwareRevisionCode: 400,
    softwareVersionName: "4.0.0 (400)",
    termsAndConditionsAccepted: true,
    termsAndConditionsAcceptedVersion: 3,
    timezone: "Bratislava",
    userServerSelection: true,
    uuid: "fsdfsd5sd-dfsdf-sdfsdf-sfsdfgsgvs",
    versionCode: 400,
    versionName: "4.0.0 (400)");

List<Object?> props = [
  31,
  {
    "classification": {"count": 4}
  },
  "Google Pixel 5",
  "no",
  "Pixel 5 5G",
  "RMBT",
  "12",
  "iOS",
  "pixel55g",
  "4.0.0",
  400,
  "4.0.0 (400)",
  true,
  3,
  "Bratislava",
  "MOBILE",
  true,
  "fsdfsd5sd-dfsdf-sdfsdf-sfsdfgsgvs",
  400,
  "4.0.0 (400)",
];

main() {
  test('checking settings', () async {
    var platform = settings.platform;
    expect(platform, 'iOS');
    expect(props, settings.props);
    expect(props, Settings.fromJson(settings.toJson()).props);
  });
}
