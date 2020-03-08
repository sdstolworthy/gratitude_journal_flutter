import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/theme/theme.dart';
import 'package:grateful/src/widgets/grateful_bloc_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  final JournalFeedBloc _journalFeedBloc =
      JournalFeedBloc(journalEntryRepository: JournalEntryRepository());

  ColorScheme getColorScheme(UserPreferenceState userPreferenceState) {
    return userPreferenceState is UserPreferencesFetched
        ? AppColorScheme.availableSchemes
            .firstWhere((AppColorScheme scheme) =>
                scheme.identifier ==
                userPreferenceState
                    .userPreferenceSettings.colorPreference.colorIdentifier)
            ?.colorScheme
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics()
      ..logEvent(name: 'opened_app');
    return AppBlocProviders(child: Builder(builder: (BuildContext context) {
      return BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
          bloc: BlocProvider.of<UserPreferenceBloc>(context),
          builder:
              (BuildContext context, UserPreferenceState userPreferenceState) {
            return BlocBuilder<LocalizationBloc, LocalizationState>(
                bloc: BlocProvider.of<LocalizationBloc>(context),
                builder: (BuildContext context, LocalizationState state) {
                  return BlocProvider<JournalFeedBloc>(
                      create: (_) => _journalFeedBloc,
                      child: MaterialApp(
                        theme: gratefulTheme(
                            colorScheme: getColorScheme(userPreferenceState)),
                        darkTheme: gratefulTheme(
                            isDark: true,
                            colorScheme: getColorScheme(userPreferenceState)),
                        localizationsDelegates: <
                            LocalizationsDelegate<dynamic>>[
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                          AppLocalizations.delegate
                        ],
                        locale: state.locale,
                        supportedLocales: AppLocalizations
                            .availableLocalizations
                            .map((AppLocale item) => Locale(item.languageCode)),
                        onGenerateRoute: Router.generatedRoute,
                        navigatorObservers: <NavigatorObserver>[
                          FirebaseAnalyticsObserver(analytics: analytics)
                        ],
                        navigatorKey: rootNavigationService.navigatorKey,
                      ));
                });
          });
    }));
  }
}
