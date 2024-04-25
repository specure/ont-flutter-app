import 'dart:collection';

import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/handlers/loop-measurement-changes-handler.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';

export '../core/unit-tests/dio-service_test.mocks.dart';

class MockNTLocales extends Mock implements NTLocales {
  @override
  HashMap<String, Language> get itsLocales => HashMap.from({
        'en': Language(
          name: 'English',
          nativeName: 'English',
          languageCode: 'en',
          countryCode: 'US',
        ),
        'de': Language(
          name: 'German',
          nativeName: 'Deutch',
          languageCode: 'de',
          countryCode: 'DE',
        )
      });
}

class MockErrorHandler extends Mock implements ErrorHandler {}

class MockMeasurementBlocLoopMeasurementChangesHandler extends Mock
    implements MeasurementBlocLoopMeasurementChangesHandler {}

class MockCoreCubitCalls extends Mock implements CoreCubit {}

typedef Callback = void Function(MethodCall call);

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
