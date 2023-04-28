import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';

class NTLocales {
  static NTLocales instance = NTLocales._();
  static HashMap<String, Language> locales = instance.itsLocales;
  HashMap<String, Language> get itsLocales => _locales;
  HashMap<String, Language> _locales = HashMap.from({
    'en': Language(
      name: 'English',
      nativeName: 'English',
      languageCode: 'en',
      countryCode: 'US',
    )
  });

  NTLocales._();

  static loadConfig() async {
    try {
      String jsonString = await rootBundle
          .loadString('config/${Environment.appSuffix}/locales.json');
      List languages = jsonDecode(jsonString);
      var locales = HashMap<String, Language>();
      languages.forEach((element) {
        var language = Language.fromJson(element);
        locales[language.getAsLocaleTag] = language;
      });
      instance._locales = locales;
    } catch (err) {
      print(err);
    }
  }
}
