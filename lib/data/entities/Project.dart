import "./userOng";
import 'dart:convert';

class Project {
  int id;
  String name;
  String description;
  String location;
  double lat;
  double lng;
  String mission;
  List<dynamic> functions;
  List<dynamic> requirements;
  DateTime creationDate;
  UserOng ongId;
  List<dynamic> photoUrls;
  int cantApplications;
  int volunteerApplicationId;

  Project({
    this.id,
    this.name,
    this.description,
    this.location,
    this.lat,
    this.lng,
    this.mission,
    this.functions,
    this.requirements,
    this.creationDate,
    this.ongId,
    this.photoUrls,
    this.cantApplications,
    this.volunteerApplicationId,
  });
  Project.fromJson(Map jsontmp) {
    this.id = jsontmp["id"];
    this.name = jsontmp["name"];
    this.description = jsontmp["description"];
    this.location = jsontmp["location"];
    this.lat = jsontmp["lat"];
    this.lng = jsontmp["lng"];
    this.mission = jsontmp["mission"];
    this.functions = json.decode(jsontmp["functions"]);
    this.requirements = json.decode(jsontmp["requirements"]);
    this.creationDate = DateTime.parse(jsontmp["creation_date"]);
    this.ongId = new UserOng.fromJson(jsontmp["ong_id"]);
    this.photoUrls = json.decode(jsontmp["photo_urls"]);
    this.cantApplications = jsontmp["cantApplications"];
    this.volunteerApplicationId = jsontmp["volunteer_application_id"];
  }
}
