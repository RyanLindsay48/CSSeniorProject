import 'package:flutter/material.dart';
import 'main.dart';

/**
 * This file is used to display an interface for the user to create an account with
 * the HouseHawk mobile application. It contains textboxes for first and last names,
 * home address, email address, username, password and confirm password
 * It also includes a button to create an account which would direct you back to the
 * login screen if it works correctly however I am experiencing a bug while trying to
 * navigate between pages
 */
class CreateAccountScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //title: 'Login page',
        home: new Scaffold(
            appBar: new AppBar(
              title:new Text(
                'Create Account',
              ),
            ),
            body:new Container(
                child:new ListView(
                  children: <Widget>[
                    new Center(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            labelText: 'firstname'
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'lastname'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'home address'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'email address'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'desired username'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'desired password'
                      ),
                    ),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'confirm password'
                      ),
                    ),
                    RaisedButton(child:new Text('Create Account'),
                        onPressed: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => new MyApp()),
                          );
                        }),
                  ],
                )
            )
        )
    );
  }
}
