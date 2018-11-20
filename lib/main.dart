import 'dart:async' show Future;
import 'dart:io';

import 'package:actualhousehawk/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'CreateAccountScreen.dart';
import 'ResetPassword.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(new HouseHawk());

class HouseHawk extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LoginScreen()
    );

  }

}
/*
  This file is is the home screen for the HouseHawk mobile application.
  It includes text fields for username and password.
  It includes a button to login to the home screen as well as links to create an
  account or reset you password
  11/01/2018 NOTE: Currently experiencing a page navigation bug on this file as
  well as the 'Create Account.dart' file
  ForgotPasswordScreen is also not created yet. (line 59)
 */
class LoginScreen extends StatelessWidget {
  String email = '';
  String password = '';
  bool invalidLogin = true;

  //Method to recieve data
  Future<User> fetchPost(BuildContext context) async {
    print('hello');
    //final response =await http.get('http://52.91.107.223:5000/user');

    final response = await http.get(
        'http://52.91.107.223:5000/user/login?email=' + email);
    print(response.statusCode);
    print('did I get this far');
    if (response.statusCode == 200) {
      print('did work');
      print(response.body);

      User user = new User.fromJson(json.decode(response.body));
      print('Email: ' + user.email_address);
      print('fname: ' + user.fname);
      print('lname: ' + user.lname);
      print('password: ' + user.password);
      print(user.user_id.toString());

      if (user.email_address == email && user.password == password) {
        print('User successfully logged in');
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new HomeScreen()));
        return User.fromJson(json.decode(response.body));
      }
    }
    else {
      print('invalid Login please try again');

      throw Exception('Failed to load post');
    }
  }

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
                  child: new TextField(
                    //Controller: email,
                    decoration: new InputDecoration(
                      labelText: 'EmailAddress'
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      print('Email Address is:  $text');
                      email = text;
                    },
                  ),

              ),
              new TextField(
                  //Controller: pass,
                  obscureText: true,
                  decoration: new InputDecoration(
                      labelText: 'password'
                  ),
                onChanged: (text) {
                  print('Password is:  $text');
                  password = text;
                },
              ),
              //Page navigation does not currently work
              RaisedButton(child: Text('Login'),
                //onPressed: ()=> fetchPost(),
                 //onPressed: ()=> fetchPost(email_address,password),//{
                  onPressed: ()=> fetchPost(context),
//                      Navigator.push(
//                          context, new MaterialPageRoute(builder: (context) => new DummyEndpoint()),
//                        )
              ),

              new InkWell(
                  child:new Text("Dont have an account? Create one"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => new CreateAccountScreen()),
                    );
                  }
              ),
              new InkWell(
                  child:new Text("Forgot Password?"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()),
                    );
                  }
              ),
            ],
          )
        )
      )
    );
  }

}
