import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/page_view/bloc.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/screens/edit_journal_entry/edit_journal_entry.dart';
import 'package:grateful/src/screens/journal_entry_feed/journal_entry_feed.dart';
import 'package:grateful/src/screens/settings/settings_screen.dart';
import 'package:grateful/src/widgets/navigation_bar.dart';

enum Page { entryEdit, entryFeed }

const List<Page> _pageOrder = <Page>[Page.entryEdit, Page.entryFeed];

class JournalPageArguments {
  JournalPageArguments({Page page, this.entry})
      : page = page ?? Page.entryEdit,
        isEdit = entry != null;

  final JournalEntry entry;
  final bool isEdit;
  final Page page;
}

class JournalPageView extends StatefulWidget {
  const JournalPageView({Page initialPage, this.journalEntry})
      : initialPage = initialPage ?? Page.entryEdit;

  final Page initialPage;
  final JournalEntry journalEntry;

  @override
  State<StatefulWidget> createState() => _JournalPageView();
}

class _JournalPageView extends State<JournalPageView> {
  StreamSubscription<void> activeCanceller;
  bool isActive;

  PageViewBloc _pageViewBloc = PageViewBloc();

  @override
  void initState() {
    setActive(true);
    _pageViewBloc =
        PageViewBloc(initialPage: _pageOrder.indexOf(widget.initialPage) ?? 0);
    super.initState();
  }

  void setActive(bool active) {
    setState(() {
      isActive = active;
    });
    if (active == true) {
      activeCanceller?.cancel();
      activeCanceller = Future<void>.delayed(const Duration(seconds: 2))
          .asStream()
          .listen((_) {
        if (mounted) {
          setState(() {
            setActive(false);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext c) {
    return BlocProvider<PageViewBloc>(
        create: (BuildContext context) => _pageViewBloc,
        child: BlocBuilder<PageViewBloc, PageViewState>(
            bloc: _pageViewBloc,
            builder: (BuildContext context, PageViewState state) {
              _pageViewBloc.pageController.addListener(() {
                /// When changing pages, hide the keyboard
                FocusScope.of(context).requestFocus(FocusNode());
              });
              if (state is CurrentPage) {
                return GestureDetector(
                  onTapDown: (_) {
                    setActive(true);
                  },
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(children: <Widget>[
                          PageView(
                            controller: _pageViewBloc.pageController,
                            children: <Widget>[
                              EditJournalEntry(item: widget.journalEntry),
                              JournalEntryFeed(),
                              SettingsScreen()
                            ],
                          ),
                        ]),
                      ),
                      NavigationBar(
                        currentIndex: _pageViewBloc.pageController.hasClients
                            ? _pageViewBloc.pageController.page
                            : 0,
                        onSelectTab: (int newTabIndex) {
                          _pageViewBloc.pageController.jumpToPage(newTabIndex);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}
