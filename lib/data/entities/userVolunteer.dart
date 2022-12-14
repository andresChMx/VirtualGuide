// Generated by https://quicktype.io
import 'package:intl/intl.dart';

class UserVolunteer {
  int id;
  String name;
  String email;
  String password;
  int role;
  String firstName;
  String lastName;
  String birthDate;
  int genre;
  int experience;
  String dni;

  UserVolunteer({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.genre,
    this.experience,
    this.dni,
  });
  UserVolunteer.fromJson(Map jsonTemp) {
    this.id = jsonTemp["id"];
    this.name = jsonTemp["name"];
    this.email = jsonTemp["email"];
    this.password = jsonTemp["password"];
    this.role = jsonTemp["role"];
    this.firstName = jsonTemp["firstName"];
    this.lastName = jsonTemp["lastName"];
    this.birthDate = jsonTemp["birthDate"];
    this.genre = jsonTemp["genre"];
    this.experience = jsonTemp["experience"];
    this.dni = jsonTemp["dni"];
  }
}
