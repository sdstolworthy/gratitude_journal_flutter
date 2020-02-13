import 'package:flutter/material.dart';

class YearSeparator extends StatelessWidget {
  const YearSeparator(this.year);

  final String year;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              year,
              style: theme.primaryTextTheme.subhead,
            )
          ],
        ),
      ),
    );
  }
}
