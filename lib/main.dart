import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ppa_app/screens/map_preview.dart';
import 'package:ppa_app/screens/splash.dart';

void main() => runApp(PpaApp());

class PpaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [const Locale('en')],
        title: 'PPA App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash(),
        routes: <String, WidgetBuilder>{
          '/map_preview': (BuildContext context) => MapPreview()
        });
  }
}
