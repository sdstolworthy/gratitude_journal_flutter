import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/screens/loading_screen/loading_tasks/loading_task.dart';

class LoadUserPreferences extends LoadingTask {
  final BuildContext context;

  LoadUserPreferences(this.context) : super('Loading User Preferences');

  @override
  Future<void> execute() async {
    BlocProvider.of<UserPreferenceBloc>(context).add(FetchUserPreferences());
  }
}
