import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class MaterialLocalizationSrMeLatnDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  /// Here list supported country and language codes
  @override
  bool isSupported(Locale locale) => locale.languageCode == "sr_ME";

  /// Here create an instance of your [MaterialLocalizations] subclass
  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      MaterialLocalizationSrMeLatn(
        compactDateFormat: DateFormat.yMd(),
        fullYearFormat: DateFormat.yMMMMd(),
        decimalFormat: NumberFormat.decimalPattern(),
        longDateFormat: DateFormat.yMMMMd(),
        mediumDateFormat: DateFormat.yMMMd(),
        shortDateFormat: DateFormat.yMd(),
        shortMonthDayFormat: DateFormat.Md(),
        twoDigitZeroPaddedFormat: NumberFormat.decimalPattern(),
        yearMonthFormat: DateFormat.yM(),
      );

  @override
  bool shouldReload(_) => false;
}

class MaterialLocalizationSrMeLatn extends MaterialLocalizationSrLatn {
  MaterialLocalizationSrMeLatn({
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });
}

class CupertinoLocalizationSrMeLatnDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  /// Here list supported country and language codes
  @override
  bool isSupported(Locale locale) => locale.languageCode == "sr_ME";

  /// Here create an instance of your [MaterialLocalizations] subclass
  @override
  Future<CupertinoLocalizations> load(Locale locale) async =>
      CupertinoLocalizationSrMeLatn(
        fullYearFormat: DateFormat.yMMMMd(),
        decimalFormat: NumberFormat.decimalPattern(),
        mediumDateFormat: DateFormat.yMMMd(),
        dayFormat: DateFormat.d(),
        doubleDigitMinuteFormat: DateFormat.m(),
        singleDigitHourFormat: DateFormat.H(),
        singleDigitMinuteFormat: DateFormat.m(),
        singleDigitSecondFormat: DateFormat.s(),
        weekdayFormat: DateFormat.E(),
      );

  @override
  bool shouldReload(_) => false;
}

class CupertinoLocalizationSrMeLatn extends CupertinoLocalizationSrLatn {
  CupertinoLocalizationSrMeLatn({
    required super.fullYearFormat,
    required super.dayFormat,
    required super.mediumDateFormat,
    required super.singleDigitHourFormat,
    required super.singleDigitMinuteFormat,
    required super.doubleDigitMinuteFormat,
    required super.singleDigitSecondFormat,
    required super.decimalFormat,
    required super.weekdayFormat,
  });
}
