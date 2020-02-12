import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/widgets/logo_hero.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[LogoHero(), const CircularProgressIndicator()],
      ),
    );
  }
}
