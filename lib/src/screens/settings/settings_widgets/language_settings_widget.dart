import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/widgets/language_picker.dart';
import 'package:intl/intl.dart';

class LanguageSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserPreferenceBloc userPreferenceBloc = BlocProvider.of<UserPreferenceBloc>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
        bloc: userPreferenceBloc,
        builder: (BuildContext context, UserPreferenceState userPreferenceState) {
          if (userPreferenceState is! UserPreferencesFetched) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: theme.iconTheme.color,
                  ),
                  title: Text(
                    toBeginningOfSentenceCase(localizations.language),
                    style: theme.primaryTextTheme.body1,
                  ),
                  trailing: LanguagePicker(),
                )
              ],
            );
          }
        });
  }
}
