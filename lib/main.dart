
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'CreateAccountScreen.dart';
import 'ResetPassword.dart';
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
  String userEmail = '';
  String userPassword = '';
  List data;

      //Method to insert data
      Future<HttpClientResponse> foo() async{
        Map<String,dynamic> jsonMap = {"email_address": "dildos@rowan.edu", "fname": "dildo","lname":"dildo","password":"dildo"};//,"phone_id":12345678910};
          Response r = await post('http://52.91.107.223:5000/create',body: json.encode(jsonMap));
          print(r.statusCode);


        }

    //Method to recieve data
    Future<Post> fetchPost() async{ //String em, String pass
//      em = email_address;
//      pass = password;
      print('hello');
      //final response =await http.get('http://52.91.107.223:5000/user');
      final response =await http.get('http://52.91.107.223:5000/user/email_address/' + email);
      print(response.statusCode);
      print('did I get this far');
      if(response.statusCode == 200){
        print('did work');
        print(response.body);
        //Post.fromJson(json.decode(response.body));
        //Post user = json.decode(response.body);
//        print('Email: ' +response.body.email_address);
//        print('fname: ' +user.fname);
//        print('lname: ' +user.lname);
//        print('password: ' + user.password);
//        print(user.user_id.toString());
//        print(response.body[3]);
        if(response.body[0] == email && response.body[3] == password){
          print('User successfully logged in');
        }
        else{
          print('somehthing is wrong');
        }

        return Post.fromJson(json.decode(response.body));
      } else {
        print('didnt work');
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
                  onPressed: ()=> foo(),
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
//              new Text ("Email : " +Post.email_address),
//              new Text ("fname : " +data[1]),
//              new Text ("lname : " +data[2]),
//              new Text ("Password : " +data[3]),
//              new Text ("phone_id : " +data[4]),
//              new Text ("user_id : " +data[5]),
//              new Text ("fname : $fname"),
            ],
          )
        )
      )
    );
  }
}

class Post {
  final String email_address;
  final String fname;
  final String lname;
  final String password;
  final int user_id;

  Post({this.email_address, this.fname, this.lname, this.password, this.user_id});

//  Post.fromJson(Map<String, dynamic> json)
//    : email_address: json['email_address'],
//      fname: json['fname'],
//      lname: json['lname'],
//      password: json['password'],
//      user_id: json['user_id'];

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email_address: json['email_address'],
      fname: json['fname'],
      lname: json['lname'],
      password: json['password'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'email_address': email_address,
        'fname': fname,
        'lname': lname,
        'password': password,
        'user_id': user_id
      };


  }




