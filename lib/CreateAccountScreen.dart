import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'user.dart';
import 'UserList.dart';

/**
 * The functionality of these classes is to allow a user to create a HomeHawk account.
 * Users are prompted to enter in their information and then if the information is valid it gets
 * sent back to the server.
 */
class CreateAccountScreen extends StatefulWidget {
  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}
/**
 * The CreateAccountScreenState is State for the CreateAccountScreen. This class takes all of the users entered info and sends it
 * back to the server. If the email entered in by the user is unique, and all of the required fields are entered in correctly
 * the account gets added to the database.
 */
class CreateAccountScreenState extends State<CreateAccountScreen> {
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
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        //title: 'Login page',
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text(
                  'Create Account',
                ),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    })),
            body: new Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: ListView(children: <Widget>[
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'Firstname'),
                        validator: (text) =>
                            text == '' ? 'FirstName is Required!' : null,
                        onSaved: (text) {
                          fname = text;
                        }),
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'Lastname'),
                        validator: (text) =>
                            text == '' ? 'Last Name is Required!' : null,
                        onSaved: (text) {
                          lname = text;
                        }),
                    TextFormField(
                        decoration:
                            new InputDecoration(labelText: 'Email Address'),
                        validator: (text) =>
                            text == '' ? 'Invalid Email address!' : null,
                        onSaved: (text) {
                          email = text;
                        }),
                    TextFormField(
                        obscureText: true,
                        decoration:
                            new InputDecoration(labelText: 'Desired Password'),
                        validator: (text) =>
                            text == '' ? 'Password is Required!' : null,
                        onSaved: (text) {
                          password = text;
                        }),
                    TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                          labelText: 'Confrim Desired Password'),
                      validator: (text) =>
                          text != password ? 'Passwords do not match!' : null,
                    ),
                    TextFormField(
                        decoration:
                            new InputDecoration(labelText: 'Street Address'),
                        keyboardType: TextInputType.text,
                        validator: (text) =>
                            text == '' ? 'Street Address is Required!' : null,
                        onSaved: (text) {
                          street_address = text;
                        }),
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'Apt. No'),
                        keyboardType: TextInputType.text,
                        onSaved: (text) {
                          apartment_number = text;
                        }),
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'City'),
                        keyboardType: TextInputType.text,
                        validator: (text) =>
                            text == '' ? 'City is Required!' : null,
                        onSaved: (text) {
                          city = text;
                        }),
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'State'),
                        validator: (text) =>
                            text == '' ? 'State is Required!' : null,
                        onSaved: (text) {
                          state = text;
                        }),
                    TextFormField(
                        decoration: new InputDecoration(labelText: 'Zip Code'),
                        validator: (text) =>
                            text == '' ? 'Zip Code is Required!' : null,
                        onSaved: (text) {
                          zip_code = text;
                        }),
                    RaisedButton(
                      child: Text('Create Account'),
                      onPressed: () => onPressed(context),
                    ),
                  ]),
                ))));
  }
  
  /**
   * The onPressed method is used to validate the TextForm fields that populate the Widget of this screen
   */
  void onPressed(BuildContext context) {
    print('Button has been pressed about to validate');
    var form = formKey.currentState;
    form.save();
    if (form.validate()) {
      print('Form Validated');
      fetchData(context);
    } else {
      print('unable to validate');
    }
  }
   /**
   * The FetchData method is used to see if the user is already in the database. We request the whole list of users
   * and loop through the list to check if the email address is located in that list.
   */
  Future<User> fetchData(BuildContext context) async {
    final response = await http.get('http://52.91.107.223:5000/users');
    if (response.statusCode == 200) {
      UserList userList = new UserList.fromJson(json.decode(response.body));
      int size = userList.users.length;
      int i = 0;
      int id = 1;
      var isValidEmail = true;
      while ((i < size) && isValidEmail) {
        if (userList.users[i].email_address == email) {
          isValidEmail = false;
        }
        if (userList.users[i].user_id >= id) {
          id = userList.users[i].user_id + 1;
        }
        i++;
      }
      user_id = id.toString();
      if (isValidEmail == false) {
        print(email + 'is already in use, please enter a new email');
        print('NOT VALID EMAIL');
      } else {
        isValid = true;
        print('VALID EMAIL CAN IT POST?');
        postData(context);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  
  /**
   * The postData method is used to put the user and their home information into the database.
   * Once the user is entered into the database the user will be redirected back to the Login Screen
   * to login to the app.
   */
  Future<HttpClientResponse> postData(BuildContext context) async {
    final response = await http.post('http://52.91.107.223:5000/user?email=' +
        email +
        '&password=' +
        password +
        '&fname=' +
        fname +
        '&lname=' +
        lname);
    if (apartment_number == '') {
      final response2 = await http.post(
          'http://52.91.107.223:5000/household?user_id=' +
              user_id +
              '&street_address=' +
              street_address +
              '&city=' +
              city +
              '&state=' +
              state +
              '&zip_code=' +
              zip_code);
    } else {
      final response3 = await http.post(
          'http://52.91.107.223:5000/household?user_id=' +
              user_id +
              '&street_address=' +
              street_address +
              '&apartment_num=' +
              apartment_number +
              '&city=' +
              city +
              '&state=' +
              state +
              '&zip_code=' +
              zip_code);
    }
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new LoginScreen()));
  }
}
