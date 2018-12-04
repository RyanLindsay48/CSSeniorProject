import 'dart:convert';
import 'Pi.dart';

class PiList {
  final List<Pi> pis;

  PiList(
      {this.pis});

  factory PiList.fromJson(List<dynamic> parsedJson) {
    List<Pi> pis = new List<Pi>();
    pis = parsedJson.map((i)=>Pi.fromJson(i)).toList();
    return new PiList(
      pis: pis,
    );
  }
}