//import 'package:flutter/material.dart';
//import 'HomeScreen.dart';
//import 'main.dart';
//import 'ResetPassword.dart';
//
//class AccountInfoScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//        title: 'Account Info Screen',
//        home: new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Account Info'),
//            leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              tooltip: 'Back to home screen',
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => HomeScreen()),
//                );
//              },
//            ),
//          ),
//          body: getListView(context),
//        ));
//  }
//
//  //This widget shows a list of the user account information
//  //If they tap on the information they will be able to edit it
//  Widget getListView(context) {
//    var listView = ListView(children: <Widget>[
//      ListTile(title: Text("First Name: $fName"), onTap: () {
//        TextFormField(
//            decoration: new InputDecoration(labelText: 'FirstName'),
//            keyboardType: TextInputType.text);
//      }),
//      ListTile(title: Text("Last Name: $lName"), onTap: () {}),
//      ListTile(title: Text("Email Address: $emailAddress"), onTap: () {}),
//      ListTile(
//          title: Text("Password: $password"),
//          onTap: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => ResetPassword()),
//            );
//          }),
//      ListTile(title: Text("Address: Your address"), onTap: () {}),
//      ListTile(title: Text("Apartment #: Your apartment number"), onTap: () {}),
//      ListTile(title: Text("State: Your state"), onTap: () {}),
//      ListTile(title: Text("City: Your City"), onTap: () {}),
//      ListTile(title: Text("Zip: Your zipcode"), onTap: () {}),
//    ]);
//    return listView;
//  }
//}