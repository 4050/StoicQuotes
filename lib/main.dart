import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:stoic_quotes_app/router/router.dart';
import 'package:stoic_quotes_app/view/view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Используем sqflite_common_ffi в среде тестирования или на десктопе
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Stoic Quotes App',
      home: HomeScreen(),
    );
  }
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
