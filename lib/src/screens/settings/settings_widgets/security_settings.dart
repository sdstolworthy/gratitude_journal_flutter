import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';
import 'package:grateful/src/services/biometrics.dart';
import 'package:grateful/src/services/localizations/localizations.dart';

class SecuritySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BiometricBloc biometricsBloc =
        BlocProvider.of<BiometricBloc>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

    final ThemeData theme = Theme.of(context);
    return BlocProvider<BiometricBloc>(
        create: (_) => biometricsBloc,
        child: Builder(builder: (BuildContext context) {
          return BlocBuilder<BiometricBloc, BiometricState>(
              bloc: biometricsBloc,
              builder: (BuildContext context, BiometricState biometricState) {
                if (biometricState is! BiometricStatusFetched) {
                  biometricsBloc.add(FetchBiometricsStatus());
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!(biometricState as BiometricStatusFetched).isCapable) {
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.fingerprint,
                          color: theme.iconTheme.color,
                        ),
                        title: Text(
                          localizations.lockJournalWithBiometrics,
                          style: theme.primaryTextTheme.body1,
                        ),
                        trailing: Switch(
                          value: (biometricState as BiometricStatusFetched)
                              .isEnabled,
                          onChanged: (bool newValue) async {
                            if (newValue) {
                              showBiometricsDialog(
                                  context: context,
                                  dialogPrompt: localizations.verifyBiometrics,
                                  onComplete: (bool authStatus) {
                                    if (authStatus) {
                                      biometricsBloc
                                          .add(ToggleBiometrics(newValue));
                                    }
                                  });
                            } else {
                              biometricsBloc.add(ToggleBiometrics(newValue));
                            }
                          },
                        ),
                      )
                    ],
                  );
                }
              });
        }));
  }
}
