class Image{
  String imageName;
  int pi_id;
  int expo_id;

  Image({this.imageName, this.pi_id, this.expo_id});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      imageName: json['image_name'],
      pi_id: json['pi_id'],
      expo_id: json['expo_id']
    );
  }


}
