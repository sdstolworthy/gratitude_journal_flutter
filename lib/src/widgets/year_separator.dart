import 'package:flutter/material.dart';

class YearSeparator extends StatelessWidget {
  const YearSeparator(this.year);

  final String year;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              year,
              style: Theme.of(context).primaryTextTheme.subhead,
            )
          ],
        ),
      ),
    );
  }
}
