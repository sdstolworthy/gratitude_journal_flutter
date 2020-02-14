import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/screens/compose_entry/compose_entry.dart';
import 'package:grateful/src/screens/garden/garden_screen.dart';
import 'package:grateful/src/screens/journal_feed/journal_feed.dart';
import 'package:grateful/src/screens/settings/settings_screen.dart';
import 'package:grateful/src/widgets/navigation_bar.dart';

enum Page { entryEdit, entryFeed, settings }

class JournalPageViewArguments {
  JournalPageViewArguments({Page page, this.entry})
      : page = page ?? Page.entryEdit,
        isEdit = entry != null;

  final JournalEntry entry;
  final bool isEdit;
  final Page page;
}

class JournalPageView extends StatefulWidget {
  const JournalPageView({int initialPage, this.journalEntry})
      : initialPage = initialPage ?? 0;

  final int initialPage;
  final JournalEntry journalEntry;

  @override
  State<StatefulWidget> createState() => _JournalPageView();
}

class _JournalPageView extends State<JournalPageView> {
  StreamSubscription<void> activeCanceller;
  bool isActive;
  int activePage;
  PageController pageController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    activePage = widget.initialPage ?? 0;
    setActive(true);
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
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
    return GestureDetector(
      onTapDown: (_) {
        setActive(true);
      },
      child: SafeArea(
        key: scaffoldKey,
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            currentIndex: activePage,
            onSelectTab: (int newTabIndex) async {
              pageController.jumpToPage(newTabIndex);
            },
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (int page) {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                activePage = page;
              });
            },
            children: <Widget>[
              GardenScreen(),
              ComposeEntry(
                item: widget.journalEntry,
                onSave: () {
                  pageController.jumpToPage(1);
                },
              ),
              const JournalFeed(),
              SettingsScreen()
            ],
          ),
        ),
      ),
    );
  }
}
