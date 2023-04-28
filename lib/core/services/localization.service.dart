import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/wrappers/platform.wrapper.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';

import '../constants/storage-keys.dart';

class LocalizationService extends DioService {
  late final Locale _locale;
  late final HashMap<String, Language> _supportedLanguages;
  Map<String, dynamic>? _translations;
  final appLocaleSeparator = "-";
  Locale? selectedLocale;
  Locale get currentLocale {
     return selectedLocale != null ? selectedLocale! : _locale;
  }
  List<Locale> get supportedLocales => _toSupportedLocales();
  final defaultLanguage = Language(
      name: 'Default',
      nativeName: 'Default',
      languageCode: 'Default',
      countryCode: 'Default');

  LocalizationService({bool testing = false})
      : super(
            baseUrl: 'https://${Environment.cmsServerUrl}', testing: testing) {
    final splittedLocaleName =
        GetIt.I.get<PlatformWrapper>().localeName.split('_');
    final languageCode = splittedLocaleName[0];
    final String? scriptCode =
        splittedLocaleName.length > 2 ? splittedLocaleName[1] : null;
    final String? countryCode = splittedLocaleName.length > 1
        ? splittedLocaleName[(splittedLocaleName.length - 1)]
        : null;
    final NTLocales localeTable = GetIt.I.get<NTLocales>();
    HashMap<String, Language> localeLanguage = localeTable.itsLocales;
    _supportedLanguages = localeLanguage;

    _loadSelectedLocale();

    var languageCodeWithScriptCode = languageCode;
    if (scriptCode != null) {
      languageCodeWithScriptCode += appLocaleSeparator + scriptCode;
    }
    final currentSupportedLanguageWithScript =
        localeTable.itsLocales.containsKey(languageCodeWithScriptCode)
            ? languageCodeWithScriptCode
            : localeTable.itsLocales.keys.first;
    final currentSupportedLanguageWithoutScript =
        localeTable.itsLocales.containsKey(languageCode)
            ? languageCodeWithScriptCode
            : localeTable.itsLocales.keys.first;
    if (currentSupportedLanguageWithScript != localeTable.itsLocales.keys.first) {
      _locale = _localeFromSupportedLanguages(
          currentSupportedLanguageWithScript, countryCode);
    } else {
      _locale = _localeFromSupportedLanguages(
          currentSupportedLanguageWithoutScript, countryCode);
    }
  }

  Future<void> _loadSelectedLocale() async {
    await GetIt.I.get<SharedPreferencesWrapper>().init();
    final selectedLanguage = loadSelectedLanguage;
    if (selectedLanguage != null) {
      selectedLocale = selectedLanguage.getAsLocale;
    } else {
      selectedLocale = null;
    }
  }

  List<Locale> _toSupportedLocales() {
    var supportedLocales = _supportedLanguages.values.map((value) {
      return Locale.fromSubtags(languageCode: value.languageCode, scriptCode: value.scriptCode, countryCode: value.countryCode);
    });
    return supportedLocales.toList();
  }

  Language? get loadSelectedLanguage {
    final selectedLocaleTag = GetIt.I.get<SharedPreferencesWrapper>().getString(StorageKeys.selectedLocaleTag);
    final splittedLocaleTag = selectedLocaleTag?.split(appLocaleSeparator);
    if (splittedLocaleTag != null) {
      if (splittedLocaleTag.length > 2) {
        return _supportedLanguages[splittedLocaleTag[0] + appLocaleSeparator + splittedLocaleTag[1]];
      } else {
        return _supportedLanguages[splittedLocaleTag[0]];
      }
    }
    return null;
  }

  Locale _localeFromSupportedLanguages(String value, String? countryCode) {
    var languageCodeSplitted = value.split(appLocaleSeparator);
    if (languageCodeSplitted.length > 1) {
      return Locale.fromSubtags(
          languageCode: languageCodeSplitted[0],
          scriptCode: languageCodeSplitted[1],
          countryCode: countryCode);
    } else {
      return Locale.fromSubtags(
          languageCode: languageCodeSplitted[0], countryCode: countryCode);
    }
  }

  String languageCodeAndScriptFromLanguageTag(String languageTag) {
    var languageCodeSplitted = languageTag.split(appLocaleSeparator);
    if (languageCodeSplitted.length > 2) {
      return languageCodeSplitted[0] + appLocaleSeparator + languageCodeSplitted[1];
    } else {
      return languageCodeSplitted[0];
    }
  }

  Future<void> getTranslations() async {
    await _loadSelectedLocale();
    try {
      final locale = toCMSLanguageCode(
          currentLocale.languageCode.toLowerCase() +
              ((currentLocale.scriptCode != null)
                  ? appLocaleSeparator + currentLocale.scriptCode!
                  : ""));
      final response = await dio.get(
        '***REMOVED***',
        queryParameters: {
          'locale.iso': locale,
          '_limit': -1,
          'app_type': 'mobile'
        },
      );
      _translations = response.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  List<Language> getSupportedLanguages() {
    return [defaultLanguage] + _supportedLanguages.values.toList();
  }

  String translate(String key) => _translations?[key] ?? key;

  String toCMSLanguageCode(String languageCode) {
    switch (languageCode) {
      case "sr-Latn":
        return "sr-Latn";
      case "sr-Cyrl":
        return "sr";
    }
    return languageCode;
  }
}
