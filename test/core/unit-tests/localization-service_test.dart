import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/locale.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';

import '../../di/service-locator.dart';
import '../../measurements/unit-tests/network-service_test.mocks.dart';

final String expectedDe =
    Locale.fromSubtags(languageCode: 'de', countryCode: 'DE').toLanguageTag();
final String expectedEn =
    Locale.fromSubtags(languageCode: 'en', countryCode: 'US').toLanguageTag();

final String? _selectedLocaleTag = null;

void main() {
  setUp(() {
    TestingServiceLocator.registerInstances();
    _setUpStubs();
  });

  test('sets locale if it is supported', () async {
    final platformWrapper = MockPlatformWrapper();
    when(platformWrapper.localeName).thenReturn('de_DE');
    TestingServiceLocator.swapLazySingleton<PlatformWrapper>(
        () => platformWrapper);
    final LocalizationService ls = LocalizationService(testing: true);
    expect(ls.currentLocale.toLanguageTag(), expectedDe);
    expect(ls.supportedLocales.map((e) => e.toLanguageTag()).toList(),
        [expectedEn, expectedDe]);
    await ls.getTranslations();
    expect('Einstellungen' , ls.translate('Settings'));
    expect('Geschwindigkeit' , ls.translate('Speed'));
  });

  test(
      'sets the first available locale if the device\'s locale is not supported',
      () {
    final LocalizationService ls = LocalizationService(testing: true);
    expect(ls.currentLocale.toLanguageTag(), expectedEn);
    expect(ls.supportedLocales.map((l) => l.toLanguageTag()).toList(),
        [expectedEn, expectedDe]);
  });
}

_setUpStubs() {
  final dio = GetIt.I.get<Dio>();
  when(GetIt.I.get<SharedPreferencesWrapper>().init()).thenAnswer((_) async => null);
  when(GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag)).thenReturn(_selectedLocaleTag);
  when(dio.get('/ui-translations', queryParameters: {
    'locale.iso': "de",
    '_limit': -1,
    'app_type': 'mobile'
  })).thenAnswer((_) async => Response(
    requestOptions: RequestOptions(path: '/ui-translations'),
    statusCode: 200,
    data: {
      'Speed' : 'Geschwindigkeit',
      'Settings' : 'Einstellungen',
    }
  ));
}