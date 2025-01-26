import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stoic_quotes_app/view/view.dart';
import 'package:firebase_core/firebase_core.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return CupertinoApp(
        navigatorObservers: [routeObserver],
        title: 'Stoic Quotes App',
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
        ),
        home: const HomeScreen(),
      );
    } else {
      return MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Stoic Quotes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      );
    }
  }
}
class RouteObserverProvider extends InheritedWidget {
  const RouteObserverProvider({required this.routeObserver, required super.child, super.key});

  final RouteObserver<PageRoute> routeObserver;

  static RouteObserver<PageRoute>? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteObserverProvider>()?.routeObserver;
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) => false;
}


/*class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Stoic Quotes App',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      routes: routes,
    );
  }
}*/
