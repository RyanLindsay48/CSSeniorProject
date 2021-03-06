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

/**
* The HomeScreen is used to help the user navigate throughout the app. On this screen the user will be able to
* navigate to: all of their cameras, their most recent exposures and their account information. The user will also
* be able to sign out of the application.
*/
class HomeScreen extends StatelessWidget {
    var mostRecentPi = '';
    /**
    * The fetchPhotos method is used to get all of the users most recent exposures.
    * It decodes the json file and stores the information in a PictureList.
    * It then loops through the Picture List and stores each Picture from that picture list as a picture object in a List.
    * It then navigates to the MostRecentExposureScreen where it passes the List of Pictures and the mostRecentPi
    */
    fetchPhotos(BuildContext context) async {
      final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id=' + globals.userID.toString()); //+globals.userID.toString());
      if (response.statusCode == 200) {
        print(response.body);
        PictureList pics = new PictureList.fromJson(json.decode(response.body));
        var size = pics.pictures.length;
        List<Picture> photos = [];
        for(int i = 0; i < size; i++){
          List<String> garbage = pics.pictures[i].filepath.split('/');
          Picture pic = new Picture();
          pic.pi_id = garbage[4];
          mostRecentPi = pic.pi_id;
          pic.expo_id = garbage[5];
          pic.imageName = garbage[6];
          photos.add(pic);
        }
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new MostRecentExposureScreen(photos, mostRecentPi)));
      }
      else {
        throw Exception('Failed to load images');
      }
  }
    /**
    * The fetchUserPis Class is used to get all of the cameras associate to a user.
    * It requests the list of cameras associated to that user and then decodes that json file into a PiList which is a list of Pi Objects
    * It then navigates to the HouseHoldCamerasScreen and the list of Pi objects gets passed into it.
    */
    fetchUserPis(BuildContext context) async {
      final response = await http.get(
          'http://52.91.107.223:5000/user/pis?id=' + globals.userID.toString());//+globals.userID.toString());
      if (response.statusCode == 200) {
        PiList userPis = new PiList.fromJson(json.decode(response.body));
        var size = userPis.pis.length;
        List<Pi> pis = [];
        for(int i = 0; i<size; i++){
          Pi pi = userPis.pis[i];
          pis.add(pi);
        }
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new HouseHoldCamerasScreen(pis)));
      }
      else {
        throw Exception('Failed to load images');
      }
    }
   /**
   * The layout used for the screen is a listView of buttons.
   */
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Home Screen')),
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
                    child: Text('Cameras'),
                    onPressed: ()=> fetchUserPis(context)
                  ),
                  RaisedButton(
                      child: new Text('View My Account Info'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountInfoScreen()),
                        );
                      }),
                  RaisedButton(
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

