import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/dio.service.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';

class CMSService extends DioService {
  final LocalizationService _localizationService =
      GetIt.I.get<LocalizationService>();
  NTProject? _project;

  NTProject? get project => _project;

  CMSService({bool testing = false})
      : super(
          baseUrl: 'https://${Environment.cmsServerUrl}',
          testing: testing,
        );

  Future<NTProject?> getProject({ErrorHandler? errorHandler}) async {
    try {
      final response = await dio.get(NTUrls.cmsProjectsRoute, queryParameters: {
        'slug': Environment.appSuffix.replaceAll('.', ''),
        '_limit': 1,
      });
      _project = NTProject.fromJson(response.data[0]);
      return _project;
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
      _project = null;
      return null;
    }
  }

  Future<String?>? getPage(String route, {ErrorHandler? errorHandler}) async {
    String? content;
    try {
      final response = await dio.get(
        NTUrls.cmsPagesRoute,
        queryParameters: {
          'menu_item.route': route,
          '_limit': 1,
        },
      );
      final List<dynamic> translations = response.data['translations'];
      Map<String, dynamic>? translation;
      try {
        final locale = _localizationService.currentLocale;
        final localeCode = _localizationService.toCMSLanguageCode(
          locale.languageCode,
          scriptCode: locale.scriptCode,
        );
        translation = translations.length > 0
            ? translations.firstWhere((e) => e['language'] == localeCode)
            : null;
      } on StateError catch (_) {}
      if (translation != null) {
        content = translation['content'];
      } else {
        content = response.data['content'];
      }
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
    }
    return content;
  }

  Future<String?>? getDescription(String route,
      {ErrorHandler? errorHandler}) async {
    String? content;
    try {
      final response = await dio.get(
        NTUrls.cmsPagesRoute,
        queryParameters: {
          'menu_item.route': route,
          '_limit': 1,
        },
      );
      final List<dynamic> translations = response.data['translations'];
      Map<String, dynamic>? translation;
      try {
        translation = translations.length > 0
            ? translations.firstWhere((e) =>
                e['language'] ==
                (_localizationService.loadSelectedLanguage?.getAsLocaleTag ??
                    _localizationService.currentLocale.languageCode))
            : null;
      } on StateError catch (_) {}
      if (translation != null) {
        content = translation['description'];
      } else {
        content = response.data['description'];
      }
    } on DioException catch (e) {
      print(e);
      errorHandler?.process(e);
    }
    return content;
  }

  getPageUrl(String page) {
    return "https://${Environment.webpageUrl}/${GetIt.I.get<LocalizationService>().loadSelectedLanguage?.getAsLocaleTag ?? "en"}/$page";
  }
}
