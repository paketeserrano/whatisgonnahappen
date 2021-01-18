import 'package:flutter/material.dart';
import 'package:youtube1/widget/button.dart';
import 'package:youtube1/widget/first.dart';
import 'package:youtube1/widget/inputEmail.dart';
import 'package:youtube1/widget/password.dart';
import 'package:youtube1/widget/textLogin.dart';
import 'package:youtube1/widget/verticalText.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:youtube1/models/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<InputEmailState> inputEmailStateKey = GlobalKey<InputEmailState>();
  final GlobalKey<PasswordInputState> passwordEmailStateKey = GlobalKey<PasswordInputState>();

  void doLogin() async{
    print("--------------Do Login function");
    print(inputEmailStateKey.currentState.emailController.text);
    print(passwordEmailStateKey.currentState.passwordController.text);

    var email = inputEmailStateKey.currentState.emailController.text;
    var password = passwordEmailStateKey.currentState.passwordController.text;

    http.Response response = await APIService.instance.loginUser(email, password);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var user = jsonDecode(response.body);
      print(user);
      sharedPrefs.username = user['username'];
      sharedPrefs.useremail = user['email'];
      sharedPrefs.userscore = user['score'];
      sharedPrefs.isloggedin = true;
      sharedPrefs.userrole = user['role'];

      // Get the user session token
      String rawCookie = response.headers['set-cookie'];
      if (rawCookie != null) {
        int index = rawCookie.indexOf(';');
        sharedPrefs.usersessiontoken = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    } else {
      throw Exception('Exception contacting the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                InputEmail(key: inputEmailStateKey),
                PasswordInput(key: passwordEmailStateKey),
                ButtonLogin(doLogin),
                FirstTime(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


