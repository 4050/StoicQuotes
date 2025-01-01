import 'package:flutter/cupertino.dart';
import 'package:stoic_quotes_app/view/view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: "Цитаты",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
            label: "Избранное",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => QuoteScreen());
          case 1:
            return CupertinoTabView(builder: (context) => FavoritesScreen());
          default:
            return CupertinoTabView(builder: (context) => QuoteScreen());
        }
      },
    );
  }
}
