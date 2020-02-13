import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/services/localizations/localizations.dart';

typedef OnChanged = void Function(String text);

class JournalInput extends StatelessWidget {
  const JournalInput({@required this.onChanged, @required this.controller});

  final TextEditingController controller;
  final OnChanged onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
        child: TextFormField(
      keyboardType: TextInputType.multiline,
      controller: controller,
      onChanged: onChanged,
      minLines: 3,
      cursorColor: theme.colorScheme.secondaryVariant,
      autocorrect: true,
      autovalidate: true,
      validator: (_) => null,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      style: Theme.of(context).primaryTextTheme.body1.copyWith(fontSize: 18),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).journalEntryHint,
        hintStyle: Theme.of(context).primaryTextTheme.body1.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
            fontStyle: FontStyle.italic),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
      ),
    ));
  }
}
