import 'package:flutter/material.dart';
import 'package:youtube1/screens/login.page.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/home_screen.dart';

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
    return MaterialApp(
      title: 'Flutter YouTube API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: renderFirstPage(),
    );
  }
}