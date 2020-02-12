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

    return Container(
      color: Colors.blue[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[LogoHero(), const CircularProgressIndicator()],
      ),
    );
  }
}
