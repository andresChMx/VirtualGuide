import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/userVolunteer.dart';

class UserProvider {
  final String _url = "https://vguidebe.herokuapp.com";
  final _prefs = new UserPreferences();
  Future<String> signinUser(
      String name,
      String lastName,
      String email,
      String password,
      String birthDate,
      String district,
      String dni,
      String genre,
      String experience) async {
    //http://10.0.2.2:8080/volunteer/signup/
    final url = Uri.parse('http://192.168.1.103:8080/volunteer/signup/');
    log("hol");
    log(name);
    final authData = {
      'birthDate': birthDate,
      'dni': dni,
      'email': email,
      'experience': 1,
      'first_name': name,
      'genre': 1,
      'last_name': lastName,
      'name': 'x',
      'password': password,
    };

    final http.Response resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));

    if (resp.statusCode == 200) {
      return Future<String>.value("ok");
    } else {
      Map decodedJson = json.decode(resp.body);
      String message = decodedJson['message'];
      if (message != null) {
        return Future.error(message);
      } else {
        return Future.error('Ocurrió un error, inténtelo mas tarde');
      }
    }
  }

  Future<String> loginUser(String email, String password) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final url = Uri.parse('http://192.168.1.103:8080/volunteer?email=' + email);
    final authData = 'Basic ' + stringToBase64.encode(email + ":" + password);
    log(authData);
    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authData
      },
    );
    log(resp.body);
    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);

      _prefs.setToken(authData);
      _prefs.setUserId(decodedJson["id"]);
      _prefs.setEmail(email);
      return Future<String>.value("ok");
    } else {
      return Future.error('Contraseña incorrecta');
    }
  }

  Future<UserVolunteer> getUserVolunteer(String email) async {
    final url = Uri.parse('http://192.168.1.103:8080/volunteer?email=' + email);

    final http.Response resp = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    log(resp.body);
    if (resp.statusCode == 200) {
      dynamic decodedJson = json.decode(resp.body);
      UserVolunteer user = UserVolunteer.fromJson(decodedJson);
      return user;
    } else {
      return Future.error('Ocurrio un error : ' + resp.statusCode.toString());
    }
  }
}
