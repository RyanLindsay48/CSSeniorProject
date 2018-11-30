class Picture {
  String imageName;
  String pi_id;
  String expo_id;

  Picture({
    this.pi_id,
    this.expo_id,
    this.imageName,
  });

  String getImageName() {
    return imageName;
  }

  String getPI() {
    return pi_id;
  }

  String getExposure() {
    return expo_id;
  }
}
