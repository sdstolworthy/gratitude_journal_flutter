import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/grateful_bloc_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';

class FlutterApp extends StatelessWidget {
  final _journalFeedBloc =
      JournalFeedBloc(journalEntryRepository: JournalEntryRepository());
  build(_) {
    final FirebaseAnalytics analytics = FirebaseAnalytics()
      ..logEvent(name: 'opened_app');
    return AppBlocProviders(child: Builder(builder: (outerContext) {
      return BlocBuilder(
          bloc: BlocProvider.of<LocalizationBloc>(outerContext),
          builder: (context, LocalizationState state) {
            return BlocProvider<JournalFeedBloc>(
                create: (_) => _journalFeedBloc,
                child: MaterialApp(
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    AppLocalizations.delegate
                  ],
                  locale: state.locale,
                  supportedLocales: AppLocalizations.availableLocalizations
                      .map((item) => Locale(item.languageCode)),
                  onGenerateRoute: Router.generatedRoute,
                  navigatorObservers: [
                    FirebaseAnalyticsObserver(analytics: analytics)
                  ],
                  navigatorKey: rootNavigationService.navigatorKey,
                ));
          });
    }));
  }
}
