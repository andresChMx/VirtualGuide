class Experience {
  int id;
  String name;
  String shortInfo;
  String latitude;
  String longitude;
  String picture;
  int tpRange;
  String province;
  int typePlace;
  bool isFavorite;
  double avgRanking;
  int nComments;

  Experience({
    this.id,
    this.name,
    this.shortInfo,
    this.latitude,
    this.longitude,
    this.picture,
    this.tpRange,
    this.province,
    this.typePlace,
    this.isFavorite,
    this.avgRanking,
    this.nComments,
  });
  Experience.fromJson(Map json) {
    this.id = json["touristicplace_id"];
    this.name = json["name"];
    this.shortInfo = json["short_info"];
    this.latitude = json["latitude"];
    this.longitude = json["longitude"];
    this.picture = json["picture"];
    this.tpRange = json["tp_range"];
    this.province = json["province_name"];
    this.typePlace = json["type_place"];
    this.isFavorite = json["isFavourite"] ?? false;
    this.avgRanking = json["avg_ranking"] / 1;
    this.nComments = json["number_comments"];
  }
  String getPosterPath() {
    return this.picture;
  }
}
