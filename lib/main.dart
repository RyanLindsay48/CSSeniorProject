import 'dart:async';

import 'package:flutter/material.dart';
import 'CreateAccountScreen.dart';
import 'ResetPassword.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(new HouseHawk());

class HouseHawk extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MyApp();
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
class MyApp extends StatelessWidget {
  String email_address = '';
  String password = '';
  String fname = '';

  //TextEditingController email = new TextEditingController();
  //TextEditingController pass = new TextEditingController();
  String url = 'http://52.91.107.223:5000/';


    Future<Post> fetchPost() async{ //String em, String pass
//      em = email_address;
//      pass = password;
      print('hello');
      final response =await http.get('http://52.91.107.223:5000/user');
      print(response.statusCode);
      if(response.statusCode == 200){
        print('did work');
        //

        //
        print(response.body);
        return Post.fromJson(json.decode(response.body));
      } else {
        print('didnt work');
        throw Exception('Failed to load post');

      }
    }


//  getData()async{
//    String profile = url;
//      var res =  await http.get(profile); //headers: {"Accept":"application/json"}
//      print(res);
//      var resBody = json.decode(res.body);
//      email_address = resBody['email_address'];
//      password = resBody['password'];
//      fname = resBody['fname'];
////      setState(() {
////        print("Success");
////      });
//  }

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
                    //controller: email,
                    decoration: new InputDecoration(
                      labelText: 'EmailAddress'
                    ),
                    keyboardType: TextInputType.text,
                  ),
              ),
//              new TextFormField(
//                  //controller: pass,
//                  obscureText: true,
//                  decoration: new InputDecoration(
//                      labelText: 'password'
//                  ),
//              ),
              //Page navigation does not currently work
              RaisedButton(child: Text('Login'),
                  onPressed: ()=> fetchPost(),
                  //onPressed: ()=> fetchPost(email_address,password),//{
                  //onPressed: ()=>
                        //Navigator.push(
                          //context, new MaterialPageRoute(builder: (context) => new CreateAccountScreen()),
                        //);}
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
              new Text ("Name : $email_address"),
              new Text ("Password : $password"),
              new Text ("fname : $fname"),
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
  final int phone_id;
  final int user_id;

  Post({this.email_address, this.fname, this.lname, this.password, this.phone_id, this.user_id});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email_address: json['email_address'],
      fname: json['fname'],
      lname: json['lname'],
      password: json['password'],
      phone_id: json['phone_id'],
      user_id: json['user_id'],
    );
  }

  getID(){
    return user_id;
  }
}


