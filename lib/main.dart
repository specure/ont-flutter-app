// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/constants/locales.dart';
import 'package:nt_flutter_standalone/core/constants/mapbox.dart';
import 'package:nt_flutter_standalone/core/constants/storage-keys.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/di/service-locator.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';
import 'package:nt_flutter_standalone/core/wrappers/firebase-analytics.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/in-app-review.wrapper.dart';
import 'package:nt_flutter_standalone/core/wrappers/shared-preferences.wrapper.dart';
import 'package:nt_flutter_standalone/modules/history/screens/filters.screen.dart';
import 'package:nt_flutter_standalone/modules/history/store/history.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/advanced-results.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/loop-measurement-result/loop-measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/home.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/servers.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-measurement/net-neutrality-measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result-details/net-neutrality-result-details.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/screens/net-neutrality-result/net-neutrality-result.screen.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/store/net-neutrality.cubit.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/welcome.screen.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/wizard.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-agreement.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/loop-mode-settings.dart';
import 'package:nt_flutter_standalone/modules/settings/screens/markdown.screen.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/constants/loop-mode.dart';
import 'modules/settings/screens/languages.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Make sure to load configs first
  await dotenv.load(fileName: '.env');
  await LoopMode.loadConfig();
  await NTLocales.loadConfig();
  await NTUrls.loadConfig();
  await NTColors.loadConfig();
  await MapBoxConsts.loadConfig();

  // Then initialize services
  ServiceLocator.registerInstances();
  await GetIt.I.get<SharedPreferencesWrapper>().init();
  await GetIt.I.get<FirebaseAnalyticsWrapper>().init();
  await GetIt.I.get<InAppReviewWrapper>().init();
  await GetIt.I.get<LocalizationService>().getTranslations();

  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
        options.tracesSampleRate = 1.0;
        options.enableNativeCrashHandling = true;
        options.enableAutoSessionTracking = true;
        options.anrEnabled = true;
        options.enableOutOfMemoryTracking = true;
      },
      appRunner: () => runApp(App()),
    );
  } else {
    runApp(App());
  }
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Environment.appSuffix == '.no'
        ? ThemeData(
            primaryColor: NTColors.primary,
            textTheme: Theme.of(context).textTheme.apply(
                  fontSizeFactor: NTDimensions.factor,
                  fontFamily: 'NewAtten',
                ),
            visualDensity: VisualDensity.compact,
            radioTheme: Theme.of(context).radioTheme.copyWith(
                  fillColor: MaterialStatePropertyAll(NTColors.primary),
                ),
          )
        : ThemeData(
            primaryColor: NTColors.primary,
            visualDensity: VisualDensity.compact,
            radioTheme: Theme.of(context).radioTheme.copyWith(
                  fillColor: MaterialStatePropertyAll(NTColors.primary),
                ),
          );
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoreCubit>(
          create: (context) => GetIt.I.get<CoreCubit>()..init(),
        ),
        BlocProvider<MeasurementsBloc>(
          create: (context) => GetIt.I.get<MeasurementsBloc>(),
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => GetIt.I.get<HistoryCubit>(),
        ),
        BlocProvider<MapCubit>(
          create: (context) => GetIt.I.get<MapCubit>(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => GetIt.I.get<SettingsCubit>(),
        ),
        BlocProvider<MeasurementResultCubit>(
          create: (context) => GetIt.I.get<MeasurementResultCubit>(),
        ),
        BlocProvider<NetNeutralityCubit>(
          create: (context) => GetIt.I.get<NetNeutralityCubit>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
        navigatorObservers: [GetIt.I.get<RouteObserver>()],
        debugShowCheckedModeBanner: false,
        title: Environment.appName,
        theme: theme,
        initialRoute: GetIt.I
                    .get<SharedPreferencesWrapper>()
                    .getBool(StorageKeys.isWizardCompleted) !=
                true
            ? WelcomeScreen.route
            : HomeScreen.route,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: GetIt.I.get<LocalizationService>().currentLocale,
        supportedLocales: GetIt.I.get<LocalizationService>().supportedLocales,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          MeasurementScreen.route: (context) => const MeasurementScreen(),
          MeasurementResultScreen.route: (context) =>
              const MeasurementResultScreen(),
          AdvancedResultsScreen.route: (context) =>
              const AdvancedResultsScreen(),
          HistoryFiltersScreen.route: (context) => const HistoryFiltersScreen(),
          MarkdownScreen.route: (context) => const MarkdownScreen(),
          LoopModeAgreementScreen.route: (context) =>
              const LoopModeAgreementScreen(),
          LoopModeSettingsScreen.route: (context) =>
              const LoopModeSettingsScreen(),
          ServersScreen.route: (context) => const ServersScreen(),
          WelcomeScreen.route: (context) => const WelcomeScreen(),
          WizardScreen.route: (context) => const WizardScreen(),
          LanguagesScreen.route: (context) => const LanguagesScreen(),
          NetNeutralityMeasurementScreen.route: (context) =>
              const NetNeutralityMeasurementScreen(),
          NetNeutralityResultScreen.route: (context) =>
              const NetNeutralityResultScreen(),
          NetNeutralityResultDetailScreen.route: (context) =>
              const NetNeutralityResultDetailScreen(),
          LoopMeasurementResultScreen.route: (context) =>
              const LoopMeasurementResultScreen(),
        },
      ),
    );
  }
}
