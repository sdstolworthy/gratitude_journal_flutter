import 'package:flutter/material.dart';

typedef OnRemove = void Function();

class DeletableResource extends StatelessWidget {
  const DeletableResource({@required this.child, @required this.onRemove});

  final Widget child;
  final OnRemove onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        child,
        Positioned(
          right: 3,
          top: 3,
          child: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.onBackground,
                borderRadius: BorderRadius.circular(35),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: const Offset(1, 1),
                      spreadRadius: 0,
                      blurRadius: 2,
                      color: Colors.grey[900])
                ]),
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.remove_circle,
                  color: theme.colorScheme.error,
                  size: 35,
                ),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onRemove),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
