import 'dart:async';
import 'dart:convert';
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

//This is where that app begins to run
//void main() => runApp(HouseHawk());

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
  ForgotPasswordScreen is also not created yet. (line 59)
 */

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var curUser;

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
    print('hello');
    print(globals.userID.toString());
    final response = await http.get(
        'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id=1'); //+globals.userID.toString());
    print(response.statusCode);
    print('did I get this far');
    //print(response.bodyBytes.toString());
    if (response.statusCode == 200) {
      print(response.body);
      PictureList pics = new PictureList.fromJson(json.decode(response.body));
      var size = pics.pictures.length;
      List<Picture> photos = [];
      for (int i = 0; i < size; i++) {
        print(pics.pictures[i].filepath);
        List<String> garbage = pics.pictures[i].filepath.split('/');
        print(garbage[6]);
        Picture pic = new Picture();
        pic.expo_id = garbage[4];
        pic.pi_id = garbage[5];
        pic.imageName = garbage[6];
        print(pic.expo_id);
        print(pic.pi_id);
        print(pic.imageName);
        print(pic);
        print(photos);
        photos.add(pic);
      }
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new MostRecentExposureScreen(photos)));
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
      curUser = User.fromJson(json.decode(response.body));

      if (curUser.emailAddress == email && curUser.password == pass) {
        print('User successfully logged in');

        // setting global variables
        globals.isLoggedIn = true;
        globals.fName = curUser.fName;
        globals.lName = curUser.lName;
        globals.emailAddress = curUser.emailAddress;
        globals.password = curUser.password;
        globals.updated = curUser.updated;
        globals.userID = curUser.userId;
        email = curUser.emailAddress;
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
      print('Didnt work, Unsuccessful connection');
      throw Exception('Failed to load post');
    }
  }

  // Fetch the updated variable
  Future fetchUserUpdated(http.Client client) async {
    print('about to run http.get user/updated');
    final response = await http.get(
        'http://52.91.107.223:5000/user/updated?user_id=' +
            globals.userID.toString());

    print('status code ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      // Connection Successful
      print('Connection Successful');
      print('response body is: ' + response.body);

      // printing 'updated' global variable

      curUser = User.fromJson(json.decode(response.body));
      globals.updated = curUser.updated;

      print('updated global is: ' + globals.updated.toString());
      print("Cur user updated is: " + curUser.updated.toString());

      if (globals.updated == 1) {
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
      print('Didnt work, Unsuccessful connection');
      throw Exception('Failed to load post');
    }
  }
}
