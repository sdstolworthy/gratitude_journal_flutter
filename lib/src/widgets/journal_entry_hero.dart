import 'package:flutter/material.dart';
import 'package:grateful/src/models/journal_entry.dart';

class JournalEntryHero extends StatelessWidget {
  const JournalEntryHero({@required this.journalEntry, this.inverted});

  final bool inverted;
  final JournalEntry journalEntry;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: journalEntry.id,
      child: Text(
        journalEntry.body,
        style: inverted == null || inverted == false
            ? Theme.of(context).primaryTextTheme.body1
            : Theme.of(context).accentTextTheme.body1,
      ),
    );
  }
}
