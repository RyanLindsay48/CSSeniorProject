import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'user.dart';
import 'UserList.dart';


class CreateAccountScreen extends StatefulWidget {
  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen>{

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
  final formKey = GlobalKey<FormState>();

  @override
  initState(){
    super.initState();
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
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      })
              ),

              body: new Padding(
                padding: EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: ListView(children: <Widget>[
                            TextFormField(
                              decoration: new InputDecoration(
                                  labelText: 'firstname'
                              ),
                              validator: (text)=> text ==''
                                  ? 'FirstName is Required!'
                                  : fname = text,
                            ),
                            TextFormField(
                              decoration: new InputDecoration(
                                  labelText: 'lastname'
                              ),
                              validator: (text)=> text ==''
                                  ? 'Last Name is Required!'
                                  : lname = text,
                            ),
                            TextFormField(
                              decoration: new InputDecoration(
                              labelText: 'email address'
                            ),
                            validator: (text)=> text ==''
                                ? 'Invalid Email address!'
                                : email = text,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: new InputDecoration(
                                labelText: 'Desired Password'
                            ),
                            validator: (text)=> text ==''
                                ? 'Password is Required!'
                                : password = text,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: new InputDecoration(
                                labelText: 'Confrim Desired Password'
                              ),
                              validator: (text)=> text == password
                                ? 'Passwords do not match!'
                                : password = text,
                              ),
                            TextFormField(
                              decoration: new InputDecoration(
                              labelText: 'Street Address'
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text)=> text ==''
                                  ? 'Street Address is Required!'
                                  : street_address = text,
                            ),
                            TextFormField(
                              decoration: new InputDecoration(
                              labelText: 'Apt. No'
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text){
                                apartment_number = text;
                              }
                            ),
                            TextFormField(
                              decoration: new InputDecoration(
                              labelText: 'City'
                              ),
                              keyboardType: TextInputType.text,
                              validator: (text)=> text ==''
                                  ? 'City is Required!'
                                  : city = text,
                            ),
                            TextFormField(
                                decoration: new InputDecoration(
                                labelText: 'State'
                                ),
                                validator: (text)=> text ==''
                                  ? 'State is Required!'
                                  : state = text,
                            ),
                            TextFormField(
                              decoration: new InputDecoration(
                              labelText: 'Zip Code'
                              ),
                              validator: (text)=> text ==''
                                ? 'Zip Code is Required!'
                                : zip_code = text,
                            ),
                            RaisedButton(child: Text('Create Account'),
                              onPressed: () => onPressed(context),
                            ),
                    ]),
                  )
              )
          )
      );
    }
  void onPressed(BuildContext context) {
    //Grab all of the form state and save it
    var form = formKey.currentState;

    // run all of the validator functions and check if we are getting null like we want or our error
    // if error then it will return false if null the return back true
    if (form.validate()) {
      // goes through all onSaved functions and saves
      form.save();

      // After text fields are saved make http request
      fetchData(context);
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



