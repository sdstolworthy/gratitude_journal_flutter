import 'package:bloc_test/bloc_test.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grateful/src/blocs/edit_journal_entry/edit_journal_entry_bloc.dart';
import 'package:grateful/src/blocs/edit_journal_entry/edit_journal_entry_event.dart';
import 'package:grateful/src/blocs/edit_journal_entry/edit_journal_entry_state.dart';
import 'package:grateful/src/blocs/journal_feed/journal_feed_bloc.dart';
import 'package:grateful/src/repositories/analytics/analytics_repository.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:mockito/mockito.dart';

class MockJournalEntryRepository extends Mock
    implements JournalEntryRepository {}

class MockJournalFeedBloc extends Mock implements JournalFeedBloc {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  group('Edit Journal Entry Bloc:', () {
    MockJournalFeedBloc mockJournalFeedBloc;
    MockAnalyticsRepository mockAnalyticsRepository;
    MockJournalEntryRepository mockJournalEntryRepository;
    EditJournalEntryBloc editJournalEntryBloc;

    setUp(() {
      mockJournalFeedBloc = MockJournalFeedBloc();
      mockAnalyticsRepository = MockAnalyticsRepository();
      mockJournalEntryRepository = MockJournalEntryRepository();
    });

    void initializeEditJournalEntryBloc() {
      editJournalEntryBloc = EditJournalEntryBloc(
          journalEntryRepository: mockJournalEntryRepository,
          journalFeedBloc: mockJournalFeedBloc,
          analyticsRepository: mockAnalyticsRepository);
    }

    void mockSaveSuccess() {
      when(mockAnalyticsRepository.logEvent(name: 'journal_entry_edit'))
          .thenAnswer((_) => null);
      when(mockJournalEntryRepository.saveItem(null)).thenAnswer((_) => null);
      initializeEditJournalEntryBloc();
    }

    void mockDeleteSuccess() {
      when(mockJournalEntryRepository.deleteItem(null)).thenAnswer((_) => null);
      initializeEditJournalEntryBloc();
    }

    void mockRepositoryError() {
      when(mockJournalEntryRepository.saveItem(null)).thenThrow(Error());
      when(mockJournalEntryRepository.deleteItem(null)).thenThrow(Error());
      initializeEditJournalEntryBloc();
    }

    blocTest<EditJournalEntryBloc, EditJournalEntryEvent,
            EditJournalEntryState>('Bloc starts with initial state', skip: 0,
        build: () async {
      initializeEditJournalEntryBloc();
      return editJournalEntryBloc;
    }, expect: <TypeMatcher<dynamic>>[isA<InitialEditJournalEntryState>()]);

    blocTest<EditJournalEntryBloc, EditJournalEntryEvent,
            EditJournalEntryState>(
        'Bloc returns Journal Entry Saved if journal entry saved correctly',
        skip: 0,
        build: () async {
          mockSaveSuccess();
          return editJournalEntryBloc;
        },
        act: (EditJournalEntryBloc editJournalEntryBloc) async =>
            editJournalEntryBloc.add(SaveJournalEntry(null)),
        expect: <TypeMatcher<dynamic>>[
          isA<InitialEditJournalEntryState>(),
          isA<JournalEntryLoading>(),
          isA<JournalEntrySaved>()
        ]);

    blocTest<EditJournalEntryBloc, EditJournalEntryEvent,
            EditJournalEntryState>(
        'Bloc returns JournalEntryDeleted if journal entry deleted correctly',
        build: () async {
          mockDeleteSuccess();
          return editJournalEntryBloc;
        },
        skip: 0,
        act: (EditJournalEntryBloc editJournalEntryBloc) async =>
            editJournalEntryBloc.add(DeleteJournalEntry(null)),
        expect: <TypeMatcher<dynamic>>[
          isA<InitialEditJournalEntryState>(),
          isA<JournalEntryLoading>(),
          isA<JournalEntryDeleted>()
        ]);

    blocTest<EditJournalEntryBloc, EditJournalEntryEvent,
            EditJournalEntryState>(
        'Bloc returns JournalEntrySaveError when saving an entry raises an error',
        build: () async {
          mockRepositoryError();
          return editJournalEntryBloc;
        },
        skip: 0,
        expect: <TypeMatcher<EditJournalEntryState>>[
          isA<InitialEditJournalEntryState>(),
          isA<JournalEntryLoading>(),
          isA<JournalEntrySaveError>()
        ],
        act: (EditJournalEntryBloc bloc) async =>
            bloc.add(SaveJournalEntry(null)));

    blocTest<EditJournalEntryBloc, EditJournalEntryEvent,
            EditJournalEntryState>(
        'Bloc returns JournalEntrySaveError when deleting an entry raises an error',
        build: () async {
          mockRepositoryError();
          return editJournalEntryBloc;
        },
        skip: 0,
        expect: <TypeMatcher<EditJournalEntryState>>[
          isA<InitialEditJournalEntryState>(),
          isA<JournalEntryLoading>(),
          isA<JournalEntrySaveError>()
        ],
        act: (EditJournalEntryBloc bloc) async =>
            bloc.add(DeleteJournalEntry(null)));
  });
}
