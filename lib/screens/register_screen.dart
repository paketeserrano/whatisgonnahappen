import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<bool> doRegister() async{
    var email = _emailController.text;
    var password = _passwordController.text;
    var username = _usernameController.text;

    http.Response response = await APIService.instance.registerUser(username, email, password);

    if (response.statusCode == 200) {
      return true;
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
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                        width: 300,
                        height: 300,
                        /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('resources/images/vid-quest-logo.png')),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter a user name'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Name field can't be empty";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email'
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
                      left: 15.0, right: 15.0, top: 15, bottom: 15),
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
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        doRegister().then((isSuccessfull){
                          if(isSuccessfull){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Success! Go to the log in page and start playing'),
                            ));
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Something went wrong. It can be a connectivity issue.'),
                            ));
                          }
                        });
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage())
                    );
                  },
                  child: Text(
                    'Go to log in page',
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