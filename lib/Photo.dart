/**
* The Photo class is used to decode a json file and store it as a Photo object.
*/
class Photo {
  final String filepath;
  final int picture_id;
  final String timestamp;

  Photo(
      {this.filepath, this.picture_id, this.timestamp});
  /**
  * The Photo.fromJson method converts json file into a Photo object.
  */
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        filepath: json['filepath'],
        picture_id: json['picture_id'],
        timestamp: json['timestamp']
    );
  }
}
