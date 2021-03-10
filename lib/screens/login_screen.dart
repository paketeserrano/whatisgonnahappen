import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/register_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void doLogin() async{
    print("--------------Do Login function");
    print(_emailController.text);
    print(_passwordController.text);

    var email = _emailController.text;
    var password = _passwordController.text;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('resources/images/flutter-logo.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'
                  ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email field can't be empty";
                      }
                      return null;
                    },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password field can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              FlatButton(
                onPressed: (){
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      doLogin();
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage())
                  );
                },
                child: Text(
                  'New User? Create Account',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      )
    );

  }
}