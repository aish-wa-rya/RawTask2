import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import '../services/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: Text('Sign in to HabitLog'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          alignment: Alignment.center,
          child: new Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Sign in anon'),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if (result == null) {
                      print('error signing in anon');
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                ),
                SignInButton(Buttons.Google,
                    onPressed: () =>
                        _auth.signInGoogle().whenComplete(() async {
                          if (_auth.getUser() != null) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            print("ERROR SIGNING IN GOOGLE");
                            //TODO
                          }
                        }))
              ])),
    );
  }
}
