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
  static String fname = '';
  static String lname = '';
  static String email = '';
  static String password = '';
  static String street_address = '';
  static String apartment_number = '';
  static String city = '';
  static String state = '';
  static String zip_code = '';
  static String user_id = '';
  static bool isValid = false;

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
                              print('FIRSTNAME IS: ' + fname);
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
                            print('LASTNAME IS: ' + lname);
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
                            print('EMAIL IS: ' + email);

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
                            print('PASSWORD IS: ' + password);
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
                            print('STREET ADDRESS IS: ' + street_address);

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
                            print('APARTMENT NUMBER IS: ' + apartment_number);

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
                            print('City IS: ' + city);

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
                            print('STATE IS: ' + state);

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
                            print('ZIP IS: ' + zip_code);

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
        i++;
      }
      user_id = id.toString();
      print(user_id);


      if(isValidEmail == false){
        print(email + 'is already in use, please enter a new email');
        print('NOT VALID EMAIL');

      }
      else{
        isValid = true;
        postData(context);
        print('VALID EMAIL CAN IT POST?');
        print(response.body);
      }
    }
    else{
      throw Exception('Failed to load post');
    }
  }

  Future<HttpClientResponse> postData(BuildContext context) async {
    print('FNAME: ' +fname);
    print('LNAME: '+lname);
    print('EMAIL: ' + email);
    print('PASSWORD: ' + password);
    print('POSTING DATA');
    final response = await http.post(
        'http://52.91.107.223:5000/user?email=' + email+'&password=' + password+'&fname=' +fname+'&lname=' + lname);
//    final response = await http.post(
//        'http://52.91.107.223:5000/user?email=canhedoit@gmail.com&password=password+&fname=bob&lname=tha builder');
    print(response.statusCode);
    print('DID THE POST WORK FOR USER?');
    if(apartment_number == ''){
      final response2 = await http.post(
          'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+street_address+'&city='+city+'&state='+state+'&zip_code='+zip_code);
      print(response2.statusCode);
      print('DID THE POST WORK FOR HOUSE2?');
    } else {
      final response3 = await http.post(
          'http://52.91.107.223:5000/household?user_id='+user_id+'&street_address='+
              street_address+'&apartment_num=' + apartment_number+ '&city='+city+'&state='+state+'&zip_code='+zip_code);
      print(response3.statusCode);
      print('DID THE POST WORK FOR HOUSE3?');
    }
    Navigator.push(context,new MaterialPageRoute(builder: (context) => new LoginScreen()));
  }
  }



