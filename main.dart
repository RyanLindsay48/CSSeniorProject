import 'package:flutter/material.dart';
import 'CreateAccountScreen.dart';
void main() => runApp(new MyApp());
/*
  This file is is the home screen for the HouseHawk mobile application.
  It includes text fields for username and password.
  It includes a button to login to the home screen as well as links to create an
  account or reset you password
  11/01/2018 NOTE: Currently experiencing a page navigation bug on this file as
  well as the 'Create Account.dart' file
  ForgotPasswordScreen is also not created yet. (line 59)
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //title: 'Login page',
      home: new Scaffold(
        appBar: new AppBar(
          title:new Text(
            'Login Screen',
          ),
        ),
        body:new Container(
          child:new ListView(
            children: <Widget>[
              new Center(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'username'
                    ),
                    keyboardType: TextInputType.text,
                  ),
              ),
              new TextFormField(
                  obscureText: true,
                  decoration: new InputDecoration(
                      labelText: 'password'
                  ),
              ),
              //Page navigation does not currently work
              RaisedButton(child: Text('Login'),
                  onPressed: () {
                        Navigator.push(
                          context, new MaterialPageRoute(builder: (context) => new CreateAccountScreen()),
                        );
              }),
              new InkWell(
                  child:new Text("Dont have an account? Create one"),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => new CreateAccountScreen()),
                    //);
                  }
              ),
              new InkWell(
                  child:new Text("Forgot Password?"),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => new ForgotPasswordScreen()),
                    //);
                  }
              ),
            ],
          )
        )
      )
    );
  }
}


