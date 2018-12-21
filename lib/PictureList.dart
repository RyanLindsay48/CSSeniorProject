import 'Photo.dart';

/**
* The PictureList class is used to decode a json file and store each Picture from that file into a list of Pictures
*/
class PictureList {
  final List<Photo> pictures;

  PictureList(
      {this.pictures});
  /**
  * The PictureList.fromJson decodes a json file and stores each element from that file as a Picture object and adds that 
  * Picture object into a list of Pictures.
  */
  factory PictureList.fromJson(List<dynamic> parsedJson) {
    List<Photo> pictures = new List<Photo>();
    pictures = parsedJson.map((i)=>Photo.fromJson(i)).toList();
    return new PictureList(
      pictures: pictures,
    );
  }
}
