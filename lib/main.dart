import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'HouseHold.dart';

import 'CreateAccountScreen.dart';
import 'HomeScreen.dart';
import 'User.dart';
import 'MostRecentExposureScreen.dart';
import 'Globals.dart' as globals;
import 'Picture.dart';
import 'PictureList.dart';
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

/// endpoint
/// users/updated

/*
  This class is is the login screen for the HouseHawk mobile application.
  It includes text fields for username and password.
  It includes a button to login to the home screen as well as links to create an
  account or reset you password
 */

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var curUser;
  String mostRecentPi = '';

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
    await fetchPhotos(context);

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

  fetchPhotos(BuildContext context) async {
    final response = await http.get(
        'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id='+globals.userID.toString());
    if (response.statusCode == 200) {
      PictureList pics = new PictureList.fromJson(json.decode(response.body));
      var size = pics.pictures.length;
      List<Picture> photos = [];
      for (int i = 0; i < size; i++) {
        List<String> garbage = pics.pictures[i].filepath.split('/');
        Picture pic = new Picture();
        pic.pi_id = garbage[4];
        mostRecentPi = pic.pi_id;
        pic.expo_id = garbage[5];
        pic.imageName = garbage[6];
        photos.add(pic);
      }
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new MostRecentExposureScreen(photos, mostRecentPi)));
    }
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
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: () async {
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

  // Fetch a JSON document that contains a user object
  // from the REST API using the http.get method.
  Future<User> fetchUser(http.Client client) async {
    final response =
    await http.get('http://52.91.107.223:5000/user/login?email=' + email);

    print(response.statusCode);
    print('did I get this far');

    if (response.statusCode == 200) {
      // Connection Successful
      //  user object to hold all of the json data
      curUser = User.fromJson(json.decode(response.body));

      if (curUser.email_address == email && curUser.password == pass) {
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

        final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/user/household?user_id=' + globals.userID.toString()); 
        if (response.statusCode == 200) {
          HouseHold house = new HouseHold.fromJson(json.decode(response.body));
          globals.household_id = house.household_id;
          globals.street_address = house.street_address;
          globals.apartment_num = house.apartment_num;
          globals.state = house.state;
          globals.city = house.city;
          globals.zip_code = house.zip_code;
        }
        else {
          throw Exception('Failed to get household info');
        }

        flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

        //ten second duration timer
        const tenSec = const Duration(seconds: 10);

        void checkAndFetch() {
          if (globals.isLoggedIn) {
            fetchUserUpdated(http.Client());
          }
        }

        Timer.periodic(tenSec, (Timer t) => checkAndFetch());

        Timer(tenSec, checkAndFetch);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print('Somehthing is wrong');
      }

      return curUser;
    } else {
      // Unsuccessful connection
      throw Exception('Failed to load post');
    }
  }


  // Fetch the updated variable
  Future fetchUserUpdated(http.Client client) async {
    final response = await http.get(
        'http://52.91.107.223:5000/user/updated?user_id=' +
            globals.userID.toString());

    if (response.statusCode == 200) {
      // Connection Successful
      // printing 'updated' global variable

      curUser = User.fromJson(json.decode(response.body));
      globals.updated = curUser.updated;

      if (globals.updated == 1) {
        sleep(const Duration(seconds: 5));
        await showNotification();

        // set gobal and curUser updated variables back to 0
        globals.updated = 0;
        curUser.updated = 0;

        // Set updated variable in database back to 0
        final response = await http.put(
            'http://52.91.107.223:5000/user/updated?user_id=' +
                globals.userID.toString() +
                '&value=' +
                '0');
      }
    } else {
      // Unsuccessful connection
      throw Exception('Failed to load post');
    }
  }
}
