import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tour_guide/data/entities/Application.dart';
import 'package:tour_guide/data/entities/Project.dart';

import '../datasource/userPreferences.dart';

class ApplicationProvider {
  Future<List<Application>> getApplicationByUser(int volunteerId) async {
    final url = Uri.parse(
        'http://192.168.1.103:8080/applications/volunteer/$volunteerId/');

    final http.Response resp = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);

      List<Application> applications = decodedJson
          .map((application) {
            return Application.fromJson(application);
          })
          .toList()
          .cast<Application>();
      ;
      return applications;
    } else {
      if (resp.statusCode == 403) {
        return Future.error('401');
      } else {
        return Future.error('500');
      }
    }
  }
}
