import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/models/project.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/modules/settings/models/language.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';

final Map<String, dynamic> _aboutPage = {
  'content': 'About',
  'translations': [
    {'content': 'Om', 'language': 'nb'}
  ]
};

final Map<String, dynamic> _methodology = {
  'description': 'Description',
  'translations': [
    {'content': 'Om', 'language': 'nb'}
  ]
};

final Map<String, dynamic> _privacyPage = {
  'content': 'Privacy',
  'translations': []
};
final List<Map<String, dynamic>> _projects = [
  {
    'mapbox_actual_date': '2022-02-03',
    'enable_app_results_sharing': false,
    'enable_app_results_synchronization': false,
    'enable_app_loop_mode': false,
    'enable_app_in_app_review': false,
    'enable_app_private_ip': false,
    'enable_app_ip_color_coding': false,
    'enable_app_language_switch': false,
    'enable_app_net_neutrality_tests': false,
    'enable_app_jitter_and_packet_loss': false,
    'enable_app_qos_result_explanation': false,
    'enable_app_qoe_result_explanation': false,
  }
];

final DioError _dioError = MockDioError();
final ErrorHandler _errorHandler = MockErrorHandler();
final _service = CMSService(testing: true);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestingServiceLocator.registerInstances();
    await dotenv.load(fileName: '.env');
    _setUpStubs();
  });

  group('CMS service', () {
    test('returns translated content for a translated page', () async {
      final content = await _service.getPage('about');
      expect(content, _aboutPage['translations'][0]['content']);
    });
    test('returns untranslated content for a not translated page', () async {
      final content = await _service.getPage('privacy');
      expect(content, _privacyPage['content']);
    });
    test('returns null when there is an error getting a page', () async {
      final content =
          await _service.getPage('error', errorHandler: _errorHandler);
      expect(content, isNull);
      verify(_errorHandler.process(_dioError));
    });
    test('returns a project if the request is successful', () async {
      final project = await _service.getProject();
      expect(project, NTProject.fromJson(_projects[0]));
    });
    test('returns a json from current mapbox date', () async {
      expect(
          _projects.first, NTProject(mapboxActualDate: '2022-02-03').toJson());
    });
    test('returns null when there is an error getting the project', () async {
      when(GetIt.I.get<Dio>().get(
        NTUrls.cmsProjectsRoute,
        queryParameters: {
          'slug': Environment.appSuffix.replaceAll('.', ''),
          '_limit': 1,
        },
      )).thenAnswer((realInvocation) async => throw _dioError);
      final project = await _service.getProject(errorHandler: _errorHandler);
      expect(project, isNull);
      verify(_errorHandler.process(_dioError));
    });
    test('returns translated description for a qos explanation', () async {
      final content = await _service.getDescription('methodology');
      expect(content, _methodology['translations'][0]['description']);
    });
  });
}

_setUpStubs() {
  when(GetIt.I.get<LocalizationService>().loadSelectedLanguage).thenReturn(
      Language(
          name: "Norway",
          nativeName: "Norks",
          languageCode: "nb",
          countryCode: "NO"));
  when(GetIt.I.get<LocalizationService>().currentLocale)
      .thenReturn(Locale.fromSubtags(languageCode: 'nb'));
  when(GetIt.I.get<Dio>().get(NTUrls.cmsPagesRoute,
          queryParameters: {'menu_item.route': 'about', '_limit': 1}))
      .thenAnswer((realInvocation) async => Response(
            requestOptions: RequestOptions(path: NTUrls.cmsPagesRoute),
            statusCode: 200,
            data: _aboutPage,
          ));
  when(GetIt.I.get<Dio>().get(NTUrls.cmsPagesRoute,
          queryParameters: {'menu_item.route': 'privacy', '_limit': 1}))
      .thenAnswer((realInvocation) async => Response(
            requestOptions: RequestOptions(path: NTUrls.cmsPagesRoute),
            statusCode: 200,
            data: _privacyPage,
          ));
  when(GetIt.I.get<Dio>().get(NTUrls.cmsPagesRoute,
          queryParameters: {'menu_item.route': 'error', '_limit': 1}))
      .thenAnswer((realInvocation) async => throw _dioError);
  when(GetIt.I.get<Dio>().get(
    NTUrls.cmsProjectsRoute,
    queryParameters: {
      'slug': Environment.appSuffix.replaceAll('.', ''),
      '_limit': 1,
    },
  )).thenAnswer((realInvocation) async => Response(
        requestOptions: RequestOptions(path: NTUrls.cmsProjectsRoute),
        statusCode: 200,
        data: _projects,
      ));
  when(_errorHandler.process(_dioError)).thenReturn(null);
  when(GetIt.I.get<Dio>().get(NTUrls.cmsPagesRoute,
          queryParameters: {'menu_item.route': 'methodology', '_limit': 1}))
      .thenAnswer((realInvocation) async => Response(
            requestOptions: RequestOptions(path: NTUrls.cmsPagesRoute),
            statusCode: 200,
            data: _methodology,
          ));
}
