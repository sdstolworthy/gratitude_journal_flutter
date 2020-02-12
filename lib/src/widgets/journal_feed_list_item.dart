import 'package:flutter/material.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:intl/intl.dart';

typedef OnPressed = void Function();

class JournalEntryListItem extends StatelessWidget {
  const JournalEntryListItem({@required this.journalEntry, this.onPressed});

  final JournalEntry journalEntry;
  final OnPressed onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FlatButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  DateFormat.d().format(journalEntry.date),
                  style: theme.primaryTextTheme.headline,
                ),
                Text(
                  DateFormat.MMM().format(journalEntry.date),
                  style: theme.primaryTextTheme.body1,
                )
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(journalEntry.body,
                  style: Theme.of(context).primaryTextTheme.body1),
            ),
          )
        ],
      ),
    );
  }
}
