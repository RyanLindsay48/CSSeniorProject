import 'dart:convert';
class Photo {
  final String filepath;
  final int picture_id;
  final String timestamp;

  Photo(
      {this.filepath, this.picture_id, this.timestamp});

  //factory User.fromJson(Map<String, String> json) => _$UserFromJson(json);
  //Map<String, String> toJson() => _$UserToJson(this);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        filepath: json['filepath'],
        picture_id: json['picture_id'],
        timestamp: json['timestamp']
    );
  }
}