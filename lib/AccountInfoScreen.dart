import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'ResetPassword.dart';
import 'Globals.dart' as globals;
import 'HouseHold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AccountInfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Account Info Screen',
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Account Info'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Back to home screen',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ),
          body: getListView(context),
        ));
  }

  //This widget shows a list of the user account information
  //If they tap on the information they will be able to edit it
  Widget getListView(context) {
    var listView = ListView(children: <Widget>[
      ListTile(title: Text("First Name: " + globals.fName), onTap: () {
        TextFormField(
            decoration: new InputDecoration(labelText: 'FirstName'),
            keyboardType: TextInputType.text);
      }),
      ListTile(title: Text("Last Name: " + globals.lName), onTap: () {}),
      ListTile(title: Text("Email Address: " + globals.emailAddress), onTap: () {}),
      ListTile(
          title: Text("Password: " + globals.password),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResetPassword()),
            );
          }),
      ListTile(title: Text("Street Address: " + globals.street_address)),
      ListTile(title: Text("Apartment #: " + globals.apartment_num)),
      ListTile(title: Text("State: " + globals.state)),
      ListTile(title: Text("City: " + globals.city)),
      ListTile(title: Text("Zip Code: " + globals.zip_code)),
    ]);
    return listView;
  }
}