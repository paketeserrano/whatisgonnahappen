import 'package:flutter/material.dart';
import 'package:youtube1/screens/login_screen.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

//void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    MyApp(),
  );
}

Widget renderFirstPage(){
  return (sharedPrefs.isloggedin) ? HomeScreen() : LoginPage();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData baseThemeData = FlexColorScheme
        .light(
      colors: FlexColor.schemes[FlexScheme.aquaBlue].light,
    ).toTheme;

    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: Splash());
          } else {
            // Loading is done, return the app:
            return MaterialApp(
              title: 'Quansers',
              debugShowCheckedModeBanner: false,
              theme: baseThemeData,
              home: renderFirstPage(),
            );
          }
        },
    );
  }
}

  class Splash extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Image(image: AssetImage('resources/images/vid-quest-logo.png'), height: 300,),
        ),
      );
    }
  }