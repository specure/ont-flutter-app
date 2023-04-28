import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/markdown.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../di/core-mocks.dart';
import '../../di/service-locator.dart';
import 'settings-screen_test.dart';

final _cubit = MockSettingsCubit();
final _initialState = SettingsState();
final _uuid = 'uuid';
final _widgetTree = BlocProvider<SettingsCubit>(
  create: (context) => GetIt.I.get<SettingsCubit>(),
  child: MaterialApp(
    home: MarkdownScreen(),
  ),
);
final _dioError = MockDioError();

final String _selectedLocaleTag = 'sr-Latn-rs';

void main() {
  setUp(() async {
    TestingServiceLocator.registerInstances(withRealLocalization: true);
    TestingServiceLocator.swapLazySingleton<SettingsCubit>(() => _cubit);
    when(GetIt.I.get<SharedPreferencesWrapper>().init())
        .thenAnswer((_) async => null);
    when(GetIt.I
            .get<SharedPreferencesWrapper>()
            .getString(StorageKeys.selectedLocaleTag))
        .thenReturn(_selectedLocaleTag);
    await dotenv.load(fileName: '.env');
  });

  group('Markdown screen', () {
    testWidgets('shows spinner and page title', (tester) async {
      final initialState = _initialState.copyWith(
        clientUuid: _uuid,
        loading: true,
        staticPageTitle: 'About',
      );
      whenListen(_cubit, Stream.fromIterable([initialState]),
          initialState: initialState);
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('shows error', (tester) async {
      final initialState = _initialState.copyWith(
        clientUuid: _uuid,
        loading: false,
        error: _dioError,
      );
      when(_dioError.message).thenReturn('error');
      whenListen(_cubit, Stream.fromIterable([initialState]),
          initialState: initialState);
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(NTErrorWidget), findsOneWidget);
    });
    testWidgets('shows content', (tester) async {
      final initialState = _initialState.copyWith(
        clientUuid: _uuid,
        loading: false,
        staticPageContent: 'Test',
      );
      whenListen(_cubit, Stream.fromIterable([initialState]),
          initialState: initialState);
      await tester.pumpWidget(_widgetTree);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(NTAppBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Html), findsOneWidget);
      when(GetIt.I.get<NavigationService>().goBack()).thenReturn(null);
      await tester.tap(find.byIcon(Icons.arrow_back));
      verify(GetIt.I.get<NavigationService>().goBack()).called(1);
    });
  });
}
