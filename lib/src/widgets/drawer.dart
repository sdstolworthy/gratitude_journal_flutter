import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/config/config.dart';
import 'package:grateful/src/screens/feedback_form/feedback_form.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/language_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

class AppDrawer extends StatelessWidget {
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  localizations.aboutGratefulButtonText,
                  style: theme.primaryTextTheme.body1,
                ),
                leading: Icon(Icons.info, color: theme.iconTheme.color),
                onTap: () {
                  rootNavigationService.navigateTo(FlutterAppRoutes.aboutApp);
                },
              ),
              ListTile(
                title: Text(localizations.shareGrateful,
                    style: theme.primaryTextTheme.body1),
                leading: Icon(
                  Icons.share,
                  color: theme.iconTheme.color,
                ),
                onTap: () {
                  Share.share(
                      '${localizations.shareJournalEntryText} ${Config.oneLinkDownload}');
                },
              ),
              ListTile(
                  onTap: () {
                    rootNavigationService.goBack();
                    rootNavigationService.navigateTo(FlutterAppRoutes.feedback,
                        arguments: FeedbackFormArgs(Scaffold.of(context)));
                  },
                  leading: Icon(Icons.feedback, color: theme.iconTheme.color),
                  title: Text(localizations.leaveFeedback,
                      style: theme.primaryTextTheme.body1)),
              ListTile(
                leading: Icon(Icons.star, color: theme.iconTheme.color),
                title: Text(localizations.writeAReview,
                    style: theme.primaryTextTheme.body1),
                onTap: () {
                  AppReview.writeReview.then((value) => print(value));
                },
              ),
              Expanded(child: Container()),
              ListTile(
                title: LanguagePicker(),
                leading: Icon(Icons.language, color: theme.iconTheme.color),
              ),
              ListTile(
                leading: Icon(Icons.vpn_key, color: theme.iconTheme.color),
                title: Text(
                  localizations.logOut,
                  style: theme.primaryTextTheme.body1,
                ),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(Unauthenticate());
                  rootNavigationService.returnToLogin();
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
