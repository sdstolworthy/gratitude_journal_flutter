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
      elevation: 5,
      selectedItemColor: Colors.white,
      backgroundColor: theme.backgroundColor,
      selectedIconTheme: theme.primaryIconTheme,
      unselectedIconTheme:
          theme.primaryIconTheme.copyWith(color: Colors.lightBlue[800]),
      selectedLabelStyle: const TextStyle(color: Colors.white),
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
