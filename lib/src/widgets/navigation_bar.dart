import 'package:flutter/material.dart';

typedef OnSelectTab = void Function(int tabIndex);

class NavigationBar extends StatefulWidget {
  const NavigationBar(
      {@required this.onSelectTab, @required this.currentIndex});

  final OnSelectTab onSelectTab;

  final int currentIndex;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<IconData> pageIcons = <IconData>[
      Icons.edit,
      Icons.list,
      Icons.settings
    ];
    return BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onSelectTab,
        elevation: 30,
        backgroundColor: theme.colorScheme.primaryVariant,
        selectedIconTheme: theme.primaryIconTheme
            .copyWith(color: theme.colorScheme.onSecondary),
        unselectedIconTheme: theme.primaryIconTheme
            .copyWith(color: theme.colorScheme.onSecondary.withOpacity(0.4)),
        unselectedLabelStyle: const TextStyle(color: Colors.white12),
        items: pageIcons.map((IconData icon) {
          return BottomNavigationBarItem(
            icon: navigationBarItem(pageIcons.indexOf(icon), icon),
            title: Container(),
          );
        }).toList());
  }

  Widget navigationBarItem(int index, IconData icon) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        width: widget.currentIndex == index ? 30 : 20,
        height: widget.currentIndex == index ? 30 : 20,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Icon(icon, size: constraints.biggest.height);
        }));
  }
}
