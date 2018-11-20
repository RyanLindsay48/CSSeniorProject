import 'dart:async' show Future;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'main.dart';
import 'user.dart';
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
  String fname = '';
  String lname = '';
  String email = '';
  String password = '';
  var body;

  Future<HttpClientResponse> postData() async {
    Map<String, dynamic> jsonMap = {
      "email_address": email,
      "fname": fname,
      "lname": lname,
      "password": password
    }; //,"phone_id":12345678910};
    final response = await http.post(
        'http://52.91.107.223:5000/create', body: json.encode(jsonMap));
    print(response.statusCode);
  }

  Future<User> fetchData() async {
    print('hello');
    //final response =await http.get('http://52.91.107.223:5000/user');

    final response = await http.get(
        'http://52.91.107.223:5000/user',
            headers: {'email_address' : email});
    //print(response.statusCode);
    print('did I get this far');
    if (response.statusCode == 200) {
      print('did work');
      print(response.body);
      body = json.decode(response.body);
    }else{
        throw Exception('Failed to load post');
    }

  }


    @override
    // ignore: unused_element
    Widget build(BuildContext context) {
      return new MaterialApp(
        //title: 'Login page',
          home: new Scaffold(
              appBar: new AppBar(
                title: new Text(
                  'Create Account',
                ),
              ),
              body: new Container(
                  child: new ListView(
                    children: <Widget>[
                      new Center(
                        child: new TextField(
                            decoration: new InputDecoration(
                                labelText: 'firstname'
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (text) {
                              print('User FirstName is:  $text');
                              fname = text;
                            }
                        ),
                      ),
                      new TextField(
                          decoration: new InputDecoration(
                              labelText: 'lastname'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User LastName is:  $text');
                            lname = text;
                          }
                      ),
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'email address'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User Email Address is:  $text');
                            email = text;

                          }
                      ),
                      new TextField(
                          obscureText: true,
                          decoration: new InputDecoration(
                              labelText: 'Desired Password'
                          ),
                          //keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('Desired Password is:  $text');
                            password = text;
                          }
                      ),
                      new TextField(
                          obscureText: true,
                          decoration: new InputDecoration(
                              labelText: 'Confrim Desired Password'
                          ),
                          //keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('Confirm Desired Password is:  $text');
                            if (password != text) {
                              print('passwords do not match');
                            }
                          }
                      ),
                      RaisedButton(child: Text('Create Account'),
                        onPressed: () => postData(),
                        //onPressed: () => fetchData(),
//                          onPressed: () {
//                            Navigator.push(
//                            context, MaterialPageRoute(builder: (context) => new LoginScreen()),
//                            );
//                          }
                      ),
                      new InkWell(
                          child: new Text("Actually have an Account? Sign in"),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => new LoginScreen()),
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
