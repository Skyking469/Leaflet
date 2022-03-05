import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/HomePage.dart';

void main() => runApp(Leaflet());

class Leaflet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorDark: Colors.green[900],
          textTheme: TextTheme(
            headline5: TextStyle(
                color: Colors.green[900], fontWeight: FontWeight.w500),
            bodyText2: TextStyle(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.green),
            fillColor: Colors.green[100],
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.green),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(Colors.green),
              fillColor: MaterialStateProperty.all(Colors.white)),
          cardTheme: CardTheme(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            backgroundColor: Colors.green[200],
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.green[200],
                statusBarIconBrightness: Brightness.dark),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              elevation: 0.0,
              enableFeedback: true,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              backgroundColor: Colors.green[200],
              unselectedItemColor: Colors.green[900],
              selectedItemColor: Colors.green[900]),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              foregroundColor: Colors.green[900])),
      title: "Leaflet",
      home: HomePage(),
      routes: {
        "/settings": (context) => const HomePage(),
      },
    );
  }
}
