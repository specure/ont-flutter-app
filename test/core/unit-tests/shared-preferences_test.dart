import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String nonExistingKey = "non_existing_key";
final String existingKey = "existingKey";

final String text = 'testString';
final String textChanged = '';

final double decimal = 1.23456789;
final double decimalChanged = 0.123456789;

final int number = 1;
final int numberChanged = 153156;

const MethodChannel _prefsChannel = const MethodChannel('nettest/preferences');
late SharedPreferencesWrapper sharedPreferences;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await _initSharedPreferences();
  });

  tearDownAll(() {
    _prefsChannel.setMockMethodCallHandler(null);
  });

  group('Shared preferences test', () {
    test('String storage', () async {
      expect(sharedPreferences.getString(nonExistingKey), null);

      sharedPreferences.setString(existingKey, text);
      expect(sharedPreferences.getString(existingKey), text);

      sharedPreferences.setString(existingKey, textChanged);
      expect(sharedPreferences.getString(existingKey), textChanged);

      sharedPreferences.remove(existingKey);
      expect(sharedPreferences.getString(existingKey), null);
    });

    test('Double storage', () async {
      expect(sharedPreferences.getDouble(nonExistingKey), null);

      sharedPreferences.setDouble(existingKey, decimal);
      expect(sharedPreferences.getDouble(existingKey), decimal);

      sharedPreferences.setDouble(existingKey, decimalChanged);
      expect(sharedPreferences.getDouble(existingKey), decimalChanged);

      sharedPreferences.remove(existingKey);
      expect(sharedPreferences.getDouble(existingKey), null);
    });

    test('Int storage', () async {
      expect(sharedPreferences.getInt(nonExistingKey), null);

      sharedPreferences.setInt(existingKey, number);
      expect(sharedPreferences.getInt(existingKey), number);

      sharedPreferences.setInt(existingKey, numberChanged);
      expect(sharedPreferences.getInt(existingKey), numberChanged);

      sharedPreferences.remove(existingKey);
      expect(sharedPreferences.getInt(existingKey), null);
    });

    test(
      'Bool storage',
      () async {
        expect(sharedPreferences.getBool(nonExistingKey), null);

        sharedPreferences.setBool(existingKey, true);
        expect(sharedPreferences.getBool(existingKey), true);

        sharedPreferences.setBool(existingKey, false);
        expect(sharedPreferences.getBool(existingKey), false);

        sharedPreferences.remove(existingKey);
        expect(sharedPreferences.getBool(existingKey), null);
      },
    );

    test('get client UUID', () async {
      _prefsChannel.setMockMethodCallHandler((call) async => 'uuid');
      expect(await sharedPreferences.clientUuid, 'uuid');
    });

    test('remove client UUID', () async {
      _prefsChannel.setMockMethodCallHandler((call) async => true);
      expect(await sharedPreferences.removeClientUuid(), true);
    });
  });
}

Future<SharedPreferencesWrapper> _initSharedPreferences() async {
  final sharedPreferences = SharedPreferencesWrapper();
  SharedPreferences.setMockInitialValues({});
  await sharedPreferences.init();
  return sharedPreferences;
}
