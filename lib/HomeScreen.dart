import 'dart:convert';
import 'package:flutter/material.dart';
import 'AccountInfoScreen.dart';
import 'HouseHoldCamerasScreen.dart';
import 'MostRecentExposureScreen.dart';
import 'package:http/http.dart' as http;
import 'Pi.dart';
import 'Globals.dart' as globals;
import 'PictureList.dart';
import 'Picture.dart';
import 'PiList.dart';
import 'main.dart';
import 'AddCamera.dart';
import 'AccountInfoScreen.dart';

class HomeScreen extends StatelessWidget {
    var mostRecentPi = '';
    fetchPhotos(BuildContext context) async {
      print('hello');
      print('DID GLOBALS TRANSFER OVER?!?!?!?!?!?' + globals.userID.toString());
      final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id=' + globals.userID.toString()); //+globals.userID.toString());
      print(response.statusCode);
      print('did I get this far');
      //print(response.bodyBytes.toString());
      if (response.statusCode == 200) {
        print(response.body);
        PictureList pics = new PictureList.fromJson(json.decode(response.body));
        var size = pics.pictures.length;
        List<Picture> photos = [];
        for(int i = 0; i < size; i++){
          print(pics.pictures[i].filepath);
          List<String> garbage = pics.pictures[i].filepath.split('/');
          print(garbage[6]);
          Picture pic = new Picture();
          pic.pi_id = garbage[4];
          mostRecentPi = pic.pi_id;
          pic.expo_id = garbage[5];
          pic.imageName = garbage[6];
          print(pic.expo_id);
          print(pic.pi_id);
          print(pic.imageName);
          print(pic);
          print(photos);
          photos.add(pic);
        }
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new MostRecentExposureScreen(photos, mostRecentPi)));
      }
      else {
        print('Cannot recieve photos');

        throw Exception('Failed to load images');
      }
  }

    fetchUserPis(BuildContext context) async {

      print('DID GLOBALS TRANSFER OVER?!?!?!?!?!?' + globals.userID.toString());
      final response = await http.get(
          'http://52.91.107.223:5000/user/pis?id=' + globals.userID.toString());//+globals.userID.toString());
      print(response.statusCode);
      print('did I get this far');
      //print(response.bodyBytes.toString());
      if (response.statusCode == 200) {
        print(response.body);
        print('http://52.91.107.223:5000/user/pis?id=1');//+globals.userID.toString());
        PiList userPis = new PiList.fromJson(json.decode(response.body));
        var size = userPis.pis.length;
        List<Pi> pis = [];
        for(int i = 0; i<size; i++){
          Pi pi = userPis.pis[i];
          print(pi.location);
          pis.add(pi);
        }
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new HouseHoldCamerasScreen(pis)));
      }
      else {
        print('Cannot recieve photos');

        throw Exception('Failed to load images');
      }
    }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Login Screen')),
          body: Padding(
              padding: EdgeInsets.all(10.0),
            child: new ListView(
               children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.only(left:10.0,right:10.0),
                    child: Text('Most recent Exposures'),
                    onPressed: ()=> fetchPhotos(context)
                  ),
                  RaisedButton(
                    //padding: const EdgeInsets.only(left:10.0,right:10.0,top:5.0,bottom:5.0),
                    child: Text('Cameras'),
                    onPressed: ()=> fetchUserPis(context)
                  ),
                  RaisedButton(
                      //padding: const EdgeInsets.only(left:10.0,right:10.0,top:5.0,bottom:5.0),
                      child: Text('Add Camera to You System'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCamera()),
                        );
                      }
                  ),
                  RaisedButton(
                      //padding: const EdgeInsets.only(left:10.0,right:10.0,top:5.0,bottom:5.0),
                      child: new Text('View My Account Info'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountInfoScreen()),
                        );
                      }),
                  RaisedButton(
                      //padding: const EdgeInsets.only(left:10.0,right:10.0,top:5.0,bottom:5.0),
                      child: new Text('Sign out'),
                      textColor: Colors.redAccent,
                      onPressed: () {
                        globals.emailAddress = '';
                        globals.fName = '';
                        globals.lName = '';
                        globals.password = '';
                        globals.userID = 0;
                        globals.updated = 0;
                        globals.isLoggedIn = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }
                  ),


                ],
              ))),
    );
  }
}

