import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language with EquatableMixin {
  final String name;
  final String nativeName;
  final String languageCode;
  final String? scriptCode;
  final String countryCode;

  Locale get getAsLocale => Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);

  String get getAsLocaleTag {
    if (scriptCode != null) {
      return '$languageCode-$scriptCode';
    } else {
      return languageCode;
    }
  }

  Language({
    required this.name,
    required this.nativeName,
    required this.languageCode,
    required this.countryCode,
    this.scriptCode,
  });

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  static List<Language> fromJsonToList(dynamic data) {
    return (data as List)
        .map((e) => Language.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object?> get props => [name, nativeName, languageCode, scriptCode, countryCode];
}
