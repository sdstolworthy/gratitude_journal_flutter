import 'package:flutter/material.dart';

typedef OnSelectTab = void Function(int tabIndex);

class NavigationBar extends StatelessWidget {
  const NavigationBar(
      {@required this.onSelectTab, @required this.currentIndex});

  final OnSelectTab onSelectTab;

  final double currentIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex.toInt(),
      onTap: onSelectTab,
      elevation: 30,
      backgroundColor: theme.colorScheme.primaryVariant,
      selectedIconTheme:
          theme.primaryIconTheme.copyWith(color: theme.colorScheme.onSecondary),
      unselectedIconTheme: theme.primaryIconTheme
          .copyWith(color: theme.colorScheme.onSecondary.withOpacity(0.4)),
      unselectedLabelStyle: const TextStyle(color: Colors.white12),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: Text('Journal', style: theme.primaryTextTheme.body1)),
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Feed', style: theme.primaryTextTheme.body1)),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings', style: theme.primaryTextTheme.body1))
      ],
    );
  }
}
