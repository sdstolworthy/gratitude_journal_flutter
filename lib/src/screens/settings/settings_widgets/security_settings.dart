import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';
import 'package:grateful/src/services/biometrics.dart';
import 'package:grateful/src/services/localizations/localizations.dart';

class SecuritySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final biometricsBloc = BlocProvider.of<BiometricBloc>(context);
    final localizations = AppLocalizations.of(context);

    final theme = Theme.of(context);
    return BlocProvider(
        create: (_) => biometricsBloc,
        child: Builder(builder: (context) {
          return BlocBuilder<BiometricBloc, BiometricState>(
              bloc: biometricsBloc,
              builder: (context, BiometricState biometricState) {
                if (biometricState is! BiometricStatusFetched) {
                  biometricsBloc.add(FetchBiometricsStatus());
                  return Center(child: CircularProgressIndicator());
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
                          onChanged: (newValue) async {
                            if (newValue) {
                              showBiometricsDialog(
                                  context: context,
                                  onComplete: (authStatus) {
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
