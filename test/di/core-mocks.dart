import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';

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

class MockDioError extends Mock implements DioError {
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);

  @override
  DioErrorType get type => (super.noSuchMethod(Invocation.getter(#message),
      returnValue: DioErrorType.other) as DioErrorType);
}

class MockErrorHandler extends Mock implements ErrorHandler {}

class MockMeasurementBlocLoopMeasurementChangesHandler extends Mock
    implements MeasurementBlocLoopMeasurementChangesHandler {}

class MockCoreCubitCalls extends Mock implements CoreCubit {}

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}
