import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import '../../measurements/unit-tests/measurements-bloc_test.mocks.dart';

void main() {
  test(
    'String.translated returns the correct string from LocalizationService',
    () {
      final String testString = 'testString';
      final localizationService = MockLocalizationService();
      when(localizationService.translate(testString)).thenReturn(testString);
      GetIt.I.registerLazySingleton<LocalizationService>(
          () => localizationService);
      expect(testString.translated, testString);
    },
  );
}
