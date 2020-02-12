import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import './bloc.dart';

class JournalFeedBloc extends Bloc<JournalFeedEvent, JournalFeedState> {
  JournalFeedBloc({@required this.journalEntryRepository});

  final JournalEntryRepository journalEntryRepository;

  @override
  JournalFeedState get initialState => JournalFeedUnloaded();

  @override
  Stream<JournalFeedState> mapEventToState(
    JournalFeedEvent event,
  ) async* {
    if (event is FetchFeed) {
      try {
        final List<JournalEntry> journalEntries =
            await journalEntryRepository.getFeed();
        if (journalEntries != null) {
          yield JournalFeedFetched(journalEntries);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
