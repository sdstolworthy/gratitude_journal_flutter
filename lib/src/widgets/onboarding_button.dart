import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({this.buttonText, this.onPressed, this.isInverted = false});

  final String buttonText;
  final bool isInverted;
  final OnPressed onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Hero(
      tag: 'onboardingButton$buttonText',
      child: ButtonTheme(
        height: 50,
        child: RaisedButton(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: onPressed == null
              ? const Center(child: CircularProgressIndicator())
              : Text(buttonText,
                  style: theme.accentTextTheme.headline.merge(TextStyle(
                      color: isInverted
                          ? theme.textTheme.headline.color
                          : theme.primaryTextTheme.headline.color))),
          color: isInverted ? theme.primaryColorLight : theme.primaryColorDark,
          highlightColor: theme.highlightColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
