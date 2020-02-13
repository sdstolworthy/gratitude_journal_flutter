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
                  title: Text('Customize App Color',
                      style: theme.primaryTextTheme.body1),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppColorScheme.availableSchemes
                        .map<Widget>((AppColorScheme scheme) {
                      return FlatButton(
                        onPressed: () {
                          userPreferenceBloc.add(
                              UpdateUserPreference<ColorPreference>(
                                  ColorPreference(
                                      colorIdentifier: scheme.identifier)));
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5)),
                                gradient: LinearGradient(
                                    colors: <Color>[
                                      scheme.colorScheme.primary,
                                      scheme.colorScheme.secondary
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            );
          }
        });
  }
}
