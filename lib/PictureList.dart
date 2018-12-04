import 'dart:convert';
import 'Photo.dart';
class PictureList {
  final List<Photo> pictures;

  PictureList(
      {this.pictures});

  factory PictureList.fromJson(List<dynamic> parsedJson) {
    List<Photo> pictures = new List<Photo>();
    pictures = parsedJson.map((i)=>Photo.fromJson(i)).toList();
    return new PictureList(
      pictures: pictures,
    );
  }
}