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

class HomeScreen extends StatelessWidget {
    fetchPhotos(BuildContext context) async {
      print('hello');
      print(globals.userID.toString());
      final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id=1'); //+globals.userID.toString());
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
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new MostRecentExposureScreen(photos)));
      }
      else {
        print('Cannot recieve photos');

        throw Exception('Failed to load images');
      }
  }

    fetchUserPis(BuildContext context) async {
      print('hello' + globals.userID.toString());
      final response = await http.get(
          'http://52.91.107.223:5000/user/pis?id=1');// + globals.userID.toString());//+globals.userID.toString());
      print(response.statusCode);
      print('did I get this far');
      //print(response.bodyBytes.toString());
      if (response.statusCode == 200) {
        print(response.body);
        print('http://52.91.107.223:5000/user/pis?id=1');//+globals.userID.toString());
        //Loop Through Json file and create pi object from each entry and add to pi list
        //IMMEDIATE TO DO LIST 11/30/2018
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
      title: 'Home Screen',
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Welcome to House Hawk'),
          ),
          body: new Container(
              child: new ListView(
                children: <Widget>[
                  new Center(),
                  //Page navigation does not currently work
                  RaisedButton(
                    child: Text('Most recent Exposures'),
                    onPressed: ()=> fetchPhotos(context)
                  ),

                  RaisedButton(
                    child: Text('Cameras'),
                    onPressed: ()=> fetchUserPis(context)
                  ),
                  RaisedButton(
                      child: Text('Add User Camera to System'),
                      onPressed: ()=> AddCamera()
                  ),
                  RaisedButton(
                      child: Text('Sign Out'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }
                  ),

//                  RaisedButton(
//                      child: new Text('View My Account Info'),
//                      onPressed: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => AccountInfoScreen()),
//                        );
//                      }),
                ],
              ))),
    );
  }
}

