import 'dart:async';
import 'dart:convert';
import 'package:actualhousehawk/Globals.dart';

import 'CreateAccountScreen.dart';
import 'HomeScreen.dart';
import 'User.dart';
import 'MostRecentExposureScreen.dart';
import 'Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var flutterLocalNotificationsPlugin;

void main() async {
  //Start application directly from the login screen
  runApp(
    new MaterialApp(
      home: LoginScreen(),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
//    await Navigator.push(
//      context,
//      //MaterialPageRoute(builder: (context) => ShowExposureScreen()),
//    );
  }

  Future showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'You have a new exposure',
        'Tap to view your most recent exposure ', platformChannelSpecifics,
        payload: 'User ID is ' + globals.userID.toString());
  }
  ////////////////////////////////////////////////////////

  // GLOBAL VARIABLES
  String fName = globals.fName;
  String lName = globals.lName;
  String email = globals.emailAddress;
  String pass = globals.password;
  int userId = globals.userID;

  // Global key that will allow us to access our form state
  final formKey = GlobalKey<FormState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login page',
        home: Scaffold(
            appBar: AppBar(title: Text('Login Screen')),
            body: Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                          autocorrect: false,
                          decoration:
                          InputDecoration(labelText: 'Email Address'),
                          validator: (text) => !text.contains('@')
                              ? 'Not a Valid Email address'
                              : null,

                          //Entered email is assigned to global email variable
                          onSaved: (text) {
                            email = text;
                          }),
                      TextFormField(
                        //controller: pass,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (text) =>
                          text.length < 4 ? 'Not a Valid Password' : null,
                          //Entered password is assigned to global email variable
                          onSaved: (text) {
                            pass = text;
                          }),
                      RaisedButton(
                          child: Text('Login'),
                          onPressed: () async {
                            //await showNotification();
                            onPressed();
                          }),
                      InkWell(
                          child: Text("Dont have an account? Create one"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen()),
                            );
                          }),
                      InkWell(
                          child: Text("Continue with out loggoing in"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          })
                    ])))));
  }

  void onPressed() {
    //Grab all of the form state and save it
    var form = formKey.currentState;

    // run all of the validator functions and check if we are getting null like we want or our error
    // if error then it will return false if null the return back true
    if (form.validate()) {
      // goes through all onSaved functions and saves
      form.save();

      // After text fields are saved make http request
      fetchUser(http.Client());
    }
  }

  Future fetchUserUpdated(http.Client client) async {
    print('about to run http.get user/updated');
    final response = await http.get(
        'http://52.91.107.223:5000/user/updated?user_id=' +
            globals.userID.toString());

    print('status code ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      // Connection Successful
      print('Connection Successful');
      print(response.body);

      //  user object to hold all of the json data
      var curUser = User.fromJson(json.decode(response.body));

      // printing 'updated' global variable
      print('updated global is: ' + globals.updated.toString());
      globals.updated = curUser.updated;
      if (globals.updated == 1) {
        await showNotification();
//        Map<String, dynamic> jsonMap = {
//          'user_id' : globals.userID.toString(),
//          'value' : '0'
//        };
        final response = await http.put(
            'http://52.91.107.223:5000/user/updated?user_id=' +globals.userID.toString()+ '&value=' + '0');

      }
    } else {
      // Unsuccessful connection
      print('Didnt work, Unsuccessful connection');
      throw Exception('Failed to load post');
    }
  }

  // Fetch a JSON document that contains a user object
  // from the REST API using the http.get method.
  Future<User> fetchUser(http.Client client) async {
    print('hello');
    print('fname is: $fName'); // Should be null here
    print('lname is: $lName'); // Should be null here
    print('email is: $email'); // Should be the entered email here
    print('password is: $pass'); // Should be the entered pass here

    //Call http get method to REST API endpoint
    print('about to run http.get');
    final response =
    await http.get('http://52.91.107.223:5000/user/login?email=' + email);

    print(response.statusCode);
    print('did I get this far');

    if (response.statusCode == 200) {
      // Connection Successful
      print('Connection Successful');
      print(response.body);

      //  user object to hold all of the json data
      var curUser = User.fromJson(json.decode(response.body));

      if (curUser.email_address == email && curUser.password == pass) {
        print('User successfully logged in');

        // setting global variables
        globals.isLoggedIn = true;
        globals.fName = curUser.fname;
        globals.lName = curUser.lname;
        globals.emailAddress = curUser.email_address;
        globals.password = curUser.password;
        globals.updated = curUser.updated;
        globals.userID = curUser.user_id;
        email = curUser.email_address;
        pass = curUser.password;

        // printing global variables
        print('Printing all globals');
        print('fName: ' + globals.fName);
        print('lName: ' + globals.lName);
        print('email: ' + globals.emailAddress);
        print('pass: ' + globals.password);
        print('userID: ' + globals.userID.toString());

        flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

        //ten second duration timer
        const tenSec = const Duration(seconds: 10);

        //if userLoggedIn is true do this
        if (globals.isLoggedIn) {
          new Timer.periodic(
              tenSec, (Timer t) => fetchUserUpdated(http.Client()));
        }

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print('Somehthing is wrong');
      }

      return curUser;
    } else {
      // Unsuccessful connection
      print('Didnt work, Unsuccessful connection');
      throw Exception('Failed to load post');
    }
  }
}
