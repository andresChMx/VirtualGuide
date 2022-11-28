import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/entities/Application.dart';
import 'package:tour_guide/data/entities/Project.dart';

import '../datasource/userPreferences.dart';

class ProjectProvider {
  Future<List<Project>> getNearbyProjects(double lat, double lng) async {
    final url = Uri.parse('http://192.168.1.103:8080/projects/nearby?lat=' +
        lat.toString() +
        "&lng=" +
        lng.toString());
    log(url.toString());
    final http.Response resp = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (resp.statusCode == 200) {
      List<dynamic> decodedJson = json.decode(resp.body);
      List<Project> projects = decodedJson.map((projectJson) {
        return Project.fromJson(projectJson);
      }).toList();
      return projects;
    } else {
      return Future.error('500 Server Error');
    }
  }

  Future<Project> getProjectDetails(
      String projectId, String volunteerId) async {
    final url = Uri.parse(
        'http://192.168.1.103:8080/projects/$projectId?volunteerId=$volunteerId');
    log(url.toString());
    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print("resopnde c ode: " + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(resp.body);
      log("resopnde c ode: " +
          decodedJson["volunteer_application_id"].toString());
      Project project = Project.fromJson(decodedJson);
      return project;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<List<Project>> getProjectsByOng(int ongId, int projectId) async {
    final url = Uri.parse('http://192.168.1.103:8080/projects/user/$ongId/');

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);

      List<Project> projects = decodedJson
          .map((project) {
            return Project.fromJson(project);
          })
          .where((project) {
            if (project.id == projectId) {
              return false;
            }
            return true;
          })
          .toList()
          .cast<Project>();
      ;
      return projects;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<dynamic> postPostulate(int volunteerId, int projectId) async {
    final url = Uri.parse('http://192.168.1.103:8080/applications/');
    final postulationData = {
      "creation_date": DateTime.now().toIso8601String(),
      "project_id": projectId,
      "user_volunteer_id": volunteerId,
    };
    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(postulationData));
    log(resp.statusCode.toString());

    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }

  Future<String> deletePostulation(String postulationId) async {
    final url =
        Uri.parse('http://192.168.1.103:8080/applications/$postulationId');
    final http.Response resp = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (resp.statusCode == 200) {
      return Future<String>.value("ok");
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
