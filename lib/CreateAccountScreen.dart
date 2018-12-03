import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'user.dart';
import 'UserList.dart';

class CreateAccountScreen extends StatelessWidget {
  // This widget is the root of your application.
  String fname = '';
  String lname = '';
  String email = '';
  String password = '';
  String street_address = '';
  String apartment_number = '';
  String city = '';
  String state = '';
  String zip_code = '';
  String user_id = '';
  bool isValid = false;


  Future<HttpClientResponse> postData(BuildContext context, bool valid) async {
    if(valid == true){
      Map<String, dynamic> jsonMap = {
        "email_address": email,
        "fname": fname,
        "lname": lname,
        "password": password
      }; //,"phone_id":12345678910};
      final response = await http.post(
          'http://52.91.107.223:5000/user', body: json.encode(jsonMap));
      print(response.statusCode);
      if(apartment_number == ''){
        final response = await http.post(
            'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+street_address+'&city='+city+'&state='+state+'&zip_code='+zip_code);
      } else {
        final response = await http.post(
            'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+
                street_address+'&apartment_num=' + apartment_number+ '&city='+city+'&state='+state+'&zip_code='+zip_code);
        print(response.statusCode);
      }
      print(response.statusCode);
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new LoginScreen()));
    }
  }


  Future<User> fetchData(BuildContext context) async {

    print('hello');
    //final response =await http.get('http://52.91.107.223:5000/user');

    final response = await http.get(
        'http://52.91.107.223:5000/users');
    //print(response.statusCode);
    print('did I get this far');
    print(response.statusCode);
    if (response.statusCode == 200) {
      UserList userList = new UserList.fromJson(json.decode(response.body));
      int size = userList.users.length;
      int i = 0;
      int id = 1;
      var isValidEmail = true;
      while((i < size) && isValidEmail){
        if(userList.users[i].email_address == email){
          isValidEmail = false;
        }
        if(userList.users[i].user_id > id){
          id = userList.users[i].user_id;
        }
        print(i);
      }
      user_id = id.toString();
      print(user_id);


      if(isValidEmail == false){
        print(email + 'is already in use, please enter a new email');
      }
      else{
        isValid = true;
        postData(context,isValid);
        print('did work');
        print(response.body);
      }
    }
    else{
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
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'Street Address'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User Street Address is:  $text');
                            street_address = text;

                          }
                      ),
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'Apartment Number'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User apartmentNumber is:  $text');
                            apartment_number = text;

                          }
                      ),
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'City'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User City is:  $text');
                            city = text;

                          }
                      ),
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'State'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User State is:  $text');
                            state = text;

                          }
                      ),
                      new TextField(

                          decoration: new InputDecoration(
                              labelText: 'Zip Code'
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            print('User Zip Code is:  $text');
                            zip_code = text;

                          }
                      ),
                      RaisedButton(child: Text('Create Account'),
                        onPressed: () => fetchData(context),
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


//Future<HttpClientResponse> postData(BuildContext context, bool valid) async {
//
//  Map<String, dynamic> jsonMap = {
//    "email_address": email,
//    "fname": fname,
//    "lname": lname,
//    "password": password
//  }; //,"phone_id":12345678910};
//  final response = await http.post(
//      'http://52.91.107.223:5000/user', body: json.encode(jsonMap));
//  print(response.statusCode);
//  if(apartment_number == ''){
//    final response = await http.post(
//        'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+street_address+'&city='+city+'&state='+state+'&zip_code='+zip_code);
//  } else {
//    final response = await http.post(
//        'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+
//            street_address+'&apartment_num=' + apartment_number+ '&city='+city+'&state='+state+'&zip_code='+zip_code);
//    print(response.statusCode);
//  }
//  print(response.statusCode);
//  Navigator.push(context,new MaterialPageRoute(builder: (context) => new LoginScreen()));
//
//}
