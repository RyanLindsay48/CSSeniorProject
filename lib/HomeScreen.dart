import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'AccountInfoScreen.dart';
import 'HouseHoldCamerasScreen.dart';
import 'MostRecentExposureScreen.dart';
import 'package:http/http.dart' as http;
import 'Pi.dart';
import 'Globals.dart' as globals;

class HomeScreen extends StatelessWidget {
    static List<String> photos = [];
    static List<Pi> pis = [];

    Future<File> fetchPhotos(BuildContext context) async {
      print('hello');
      //final response =await http.get('http://52.91.107.223:5000/user');

      final response = await http.get(
          'http://52.91.107.223:5000/exposure/pictures?pi_id=2&expo_id=28');
      print(response.statusCode);
      print('did I get this far');
      //print(response.bodyBytes.toString());
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        print(bytes);
        Archive archive = ZipDecoder().decodeBytes(bytes);
        print(archive);
//        final Directory tempDirectory = await getTemporaryDirectory();
//        print(tempDirectory.toString());
//        tempDirectory.createSync(recursive: true);
        for(ArchiveFile file in archive){
          photos.add(file.toString());
          print(file.toString());
        }
        Navigator.push(context,new MaterialPageRoute(builder: (context) => new MostRecentExposureScreen(photos)));
      }
      else {
        print('Cannot recieve photos');

        throw Exception('Failed to load images');
      }
  }


    Future<Pi> fetchUserPis(BuildContext context) async {
      print('hello' + globals.userID.toString());
      //final response =await http.get('http://52.91.107.223:5000/user');

      final response = await http.get(
          'http://52.91.107.223:5000/user/pis?id=0');
//      final response = await http.get(
//          'http://52.91.107.223:5000/user/pis?id=' + globals.userID.toString());
      print(response.statusCode);
      print('did I get this far');
      //print(response.bodyBytes.toString());
      if (response.statusCode == 200) {
        print(response.body);

        //Loop Through Json file and create pi object from each entry and add to pi list
        //IMMEDIATE TO DO LIST 11/30/2018
        const jsonCodec = const JsonCodec();
        Map piInfo = jsonCodec.decode(response.body);
        Pi pi = new Pi.fromJson(json.decode(response.body));
        var p = new Pi.fromJson(piInfo);
        print('Location: ' + pi.location);
        print('pi_id: ' + pi.pi_id.toString());
        print('reset: ' + pi.reset.toString());
        print('serial_number: ' + pi.serial_number);
        print('user_id: ' + pi.user_id.toString());

        pis.add(pi);


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
//                        () {
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(builder: (context) => MostRecentExposureScreen()),
//                      );
//                    },
                  ),

                  RaisedButton(
                    child: Text('Cameras'),
                    onPressed: ()=> fetchUserPis(context)
//                    {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => HouseHoldCamerasScreen()),
//                      );
//                    },
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
