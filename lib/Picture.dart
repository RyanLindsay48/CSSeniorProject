class Picture {
  String imageName;
  String pi_id;
  String expo_id;

  Picture({
    this.pi_id,
    this.expo_id,
    this.imageName,
  });
  //Look into why dart made me create getters for this class when it its fine for others to not have getters
  //Im very tired will look into later
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
