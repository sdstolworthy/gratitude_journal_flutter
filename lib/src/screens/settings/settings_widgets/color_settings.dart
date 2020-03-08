import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/models/preferences/color_preference.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/theme/theme.dart';

class ColorSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
        bloc: userPreferenceBloc,
        builder:
            (BuildContext context, UserPreferenceState userPreferenceState) {
          if (userPreferenceState is! UserPreferencesFetched) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.palette, color: theme.iconTheme.color),
                  title: Text(localizations.customizeColor,
                      style: theme.primaryTextTheme.body1),
                ),
                ListTile(
                  leading: renderLeading('blue', context),
                  title:
                      Text('Light Theme', style: theme.primaryTextTheme.body1),
                  onTap: () {
                    setColorScheme(AppColorScheme.blueScheme.identifier,
                        userPreferenceBloc);
                  },
                ),
                ListTile(
                  leading: renderLeading('black', context),
                  title:
                      Text('Dark Theme', style: theme.primaryTextTheme.body1),
                  onTap: () {
                    setColorScheme(AppColorScheme.blackScheme.identifier,
                        userPreferenceBloc);
                  },
                ),
                ListTile(
                  leading: renderLeading(null, context),
                  title:
                      Text('System Theme', style: theme.primaryTextTheme.body1),
                  onTap: () {
                    setColorScheme(null, userPreferenceBloc);
                  },
                )
              ],
            );
          }
        });
  }

  Widget renderLeading(String scheme, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
      bloc: BlocProvider.of<UserPreferenceBloc>(context),
      builder: (BuildContext context, UserPreferenceState state) {
        if (state is UserPreferencesFetched &&
            state.userPreferenceSettings?.colorPreference?.colorIdentifier ==
                scheme) {
          return Icon(Icons.check, color: theme.iconTheme.color);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void setColorScheme(
      String identifier, UserPreferenceBloc userPreferenceBloc) {
    userPreferenceBloc.add(UpdateUserPreference<ColorPreference>(
        ColorPreference(colorIdentifier: identifier)));
  }

  Widget renderColorSchemeOption(
      AppColorScheme appColorScheme, Function(AppColorScheme) onPressed) {
    return FlatButton(
      onPressed: () {
        onPressed(appColorScheme);
      },
      child: SizedBox(
        height: 40,
        width: 40,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(colors: <Color>[
                appColorScheme.colorScheme.primary,
                appColorScheme.colorScheme.secondary
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
      ),
    );
  }
}
