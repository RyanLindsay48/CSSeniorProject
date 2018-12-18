class Photo {
  final String filepath;
  final int picture_id;
  final String timestamp;

  Photo(
      {this.filepath, this.picture_id, this.timestamp});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        filepath: json['filepath'],
        picture_id: json['picture_id'],
        timestamp: json['timestamp']
    );
  }
}