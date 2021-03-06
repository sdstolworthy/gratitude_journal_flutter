import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/screens/journal_entry_details/journal_entry_details.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/journal_feed_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/widgets/full_screen_layout.dart';
import 'package:grateful/src/widgets/year_separator.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class JournalFeed extends StatefulWidget {
  const JournalFeed();
  bool get wantKeepAlive => false;

  @override
  State<StatefulWidget> createState() {
    return _JournalFeedState();
  }
}

class _JournalFeedState extends State<JournalFeed>
    with TickerProviderStateMixin {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    _refreshCompleter.complete();
    super.dispose();
  }

  List<Widget> _renderAppBar(BuildContext context, bool isScrolled) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return <Widget>[
      SliverAppBar(
        floating: true,
        elevation: 0.0,
        title: Text(localizations.previousEntries,
            style: theme.primaryTextTheme.title
                .copyWith(color: theme.colorScheme.onPrimary)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final JournalFeedBloc _journalFeedBloc =
        BlocProvider.of<JournalFeedBloc>(context);
    return BlocListener<JournalFeedBloc, JournalFeedState>(
        bloc: _journalFeedBloc,
        listener: (BuildContext context, JournalFeedState state) {
          if (state is JournalFeedFetched) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer<void>();
          }
        },
        child: BlocBuilder<JournalFeedBloc, JournalFeedState>(
          bloc: _journalFeedBloc,
          builder: (BuildContext context, JournalFeedState state) {
            if (state is JournalFeedUnloaded) {
              _journalFeedBloc.add(FetchFeed());
              return const BackgroundGradientProvider(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is JournalFeedFetched) {
              state.journalEntries.sort(_sortJournalEntriesDescendingDate);
              final Map<int, List<JournalEntry>> sortedEntriesYearMap =
                  _groupEntriesByYear(state.journalEntries);

              final List<Widget> compiledList =
                  _getJournalEntryListItemWidgets(
                      context, sortedEntriesYearMap);
              return FullScreenLayout(
                headerSliverBuilder: _renderAppBar,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return compiledList[index];
                  },
                  itemCount: compiledList.length,
                ),
              );
            }
            return Container();
          },
        ));
  }

  int _sortJournalEntriesDescendingDate(JournalEntry a, JournalEntry b) {
    return a.date.isBefore(b.date) ? 1 : -1;
  }

  Map<int, List<JournalEntry>> _groupEntriesByYear(
      List<JournalEntry> journalEntries) {
    return journalEntries
        .fold<Map<int, List<JournalEntry>>>(<int, List<JournalEntry>>{},
            (Map<int, List<JournalEntry>> previous, JournalEntry current) {
      final int year = current.date.year;
      if (previous[year] == null) {
        previous[year] = <JournalEntry>[];
      }
      previous[year].add(current);
      return previous;
    });
  }

  Widget _renderEntryListItem(JournalEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: JournalEntryListItem(
        journalEntry: entry,
        onPressed: () {
          rootNavigationService.navigateTo(FlutterAppRoutes.journalEntryDetails,
              arguments: JournalEntryDetailArguments(journalEntry: entry));
        },
      ),
    );
  }

  List<Widget> _getJournalEntryListItemWidgets(
      BuildContext context, Map<int, List<JournalEntry>> entriesByYear) {
    final ThemeData theme = Theme.of(context);
    return entriesByYear.keys.fold<List<Widget>>(<Widget>[],
        (List<Widget> previousEntries, int currentEntry) {
      return previousEntries
        ..addAll(<Widget>[
          StickyHeaderBuilder(
            builder: (BuildContext context, double stuckAmount) {
              final double opacity = 1.0 - stuckAmount.clamp(0.0, 1.0);
              return Container(
                  height: 50,
                  child: SizedBox.expand(
                      child: YearSeparator(currentEntry.toString())),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: <Color>[
                      theme.colorScheme.background.withOpacity(opacity),
                      theme.colorScheme.background.withOpacity(0.8 * opacity),
                      theme.colorScheme.background.withOpacity(0.0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )));
            },
            content: Column(
                children: entriesByYear[currentEntry].map((JournalEntry entry) {
              return _renderEntryListItem(entry);
            }).toList()),
          )
        ]);
    });
  }
}
