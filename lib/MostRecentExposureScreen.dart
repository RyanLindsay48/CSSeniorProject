import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'Picture.dart';
import 'package:http/http.dart' as http;
import 'Globals.dart' as globals;
import 'PictureList.dart';
import 'dart:convert';


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



  fetchUpdated(BuildContext context)async{
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

  putUpdate()async {
    print('Most Recent Pi is: ' + mostRecentPi);
    final response = await http.put('http://52.91.107.223:5000/pi/reset?pi_id='  + mostRecentPi +
        '&value=1');
    print(response.statusCode);
  }

  buildCells(int length) {
    List<Container> cells = new List<Container>.generate(length,(int index) {
      return new Container(
        child: new Image.network(pics[index]),
      );
    });
    return cells;
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisSpacing: 5.0,
              padding: const EdgeInsets.all(5.0),
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

