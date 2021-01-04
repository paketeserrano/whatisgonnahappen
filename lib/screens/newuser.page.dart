import 'package:flutter/material.dart';
import 'package:youtube1/widget/buttonNewUser.dart';
import 'package:youtube1/widget/newEmail.dart';
import 'package:youtube1/widget/newName.dart';
import 'package:youtube1/widget/password.dart';
import 'package:youtube1/widget/singup.dart';
import 'package:youtube1/widget/textNew.dart';
import 'package:youtube1/widget/userOld.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:youtube1/services/api_service.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final GlobalKey<NewNomeState> nameStateKey = GlobalKey<NewNomeState>();
  final GlobalKey<NewEmailState> emailStateKey = GlobalKey<NewEmailState>();
  final GlobalKey<PasswordInputState> passwordStateKey = GlobalKey<PasswordInputState>();

  void doRegister() async {
    var name = nameStateKey.currentState.nameController.text;
    var email = emailStateKey.currentState.emailController.text;
    var password = passwordStateKey.currentState.passwordController.text;

    http.Response response = await APIService.instance.registerUser(name, email, password);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var user = jsonDecode(response.body);
      print(user);
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
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                NewNome(key: nameStateKey),
                NewEmail(key: emailStateKey),
                PasswordInput(key: passwordStateKey),
                ButtonNewUser(doRegister),
                UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
