import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'Picture.dart';
import 'package:http/http.dart' as http;
import 'Globals.dart' as globals;
import 'PictureList.dart';
import 'dart:convert';

/**
* The MostRecentExposuresScreen class is used to show the users most recent exposures. It also has the ability to refresh the list
* of exposures just in case the users camera was still taking pictures by the time the user clicked on the push notification. The user 
* can also reset their camera so it stops taking pictures and they may also navigate back to the HomeScreen
*/
class MostRecentExposureScreen extends StatelessWidget {
  List<Picture> photos =[];
  String endpointBegin = 'http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/picture?expo_id=';
  String pi_id = '&pi_id=';//=28
  String imageName = '&image_name=';
  List<NetworkImage> myPhotos =[];
  var mostRecentPi = '';
  List<String> pics = [];

  MostRecentExposureScreen(List<Picture> photos, String mostRecentPi){
    this.photos = photos;
    this.mostRecentPi = mostRecentPi;
  }
  /**
  * The fetchUpdated method is used to refresh the list of pictuers that are associated to the user's most recent exposures.
  * This method decodes a json file and converts that file into a PictureList Object. The page then reloads with the updated list
  * of pictures for the user to see.
  */
  fetchUpdated(BuildContext context)async{
    final response = await http.get('http://ec2-52-91-107-223.compute-1.amazonaws.com:5000/exposure/recent?id=' + globals.userID.toString());
    if (response.statusCode == 200) {
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
        photos.add(pic);
      }
      Navigator.push(context,new MaterialPageRoute(builder: (context) => new MostRecentExposureScreen(photos, mostRecentPi)));
    }
    else {
      print('Cannot recieve photos');
      throw Exception('Failed to load images');
    }
  }
  /**
  * The putUpdate method is used for the Reset Camera button. It resets the camera so it stops taking pictures.
  */
  putUpdate()async {
    final response = await http.put('http://52.91.107.223:5000/pi/reset?pi_id='  + mostRecentPi +
        '&value=1');
  }
  /**
  * The buildCells method is used to build Containers that contain images from the user's most recent exposure.
  */
  buildCells(int length) {
    List<Container> cells = new List<Container>.generate(length,(int index) {
      return new Container(
        child: new Image.network(pics[index]),
      );
    });
    return cells;
  }
  /**
  * The layout used on this screen was a Grid Layout that displays each picture from the user's most recent
  * exposures. It also contains a button that resets the camera, a button that refreshes the screen so the user can
  * see if they have any more pictures to be seen and a back button that navigates back to the HomeScreen.
  */
  @override
  Widget build(BuildContext context) {
    //For loop used to load images
    for(Picture image in photos){
      String str = endpointBegin + image.getExposure() + pi_id + image.getPI() + imageName + image.getImageName() ;
      myPhotos.add(new NetworkImage(str));
      pics.add(str);
    }
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
                title: new Text('Most Recent Exposure'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                ),
                actions: <Widget> [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: ()=> fetchUpdated(context),
                  )
                ]
            ),
            body:  GridView.count(
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 1.3,
              childAspectRatio: 1.60,
              padding: const EdgeInsets.all(10.0),
              crossAxisCount: 2,
              children: buildCells(myPhotos.length),
            ),
            bottomNavigationBar: new Container(
                child: RaisedButton(
                  child: Text('Reset Camera'),
                  textColor: Colors.red,
                  onPressed: ()=> putUpdate(),
                )
            )
        ),
    );
  }
}

