import 'package:flutter/material.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/userVolunteer.dart';
import 'package:tour_guide/data/providers/userProvider.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

class AccountSettingsPage extends StatefulWidget {
  AccountSettingsPage({Key key}) : super(key: key);

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  UserProvider userProvider = new UserProvider();
  UserPreferences userPreferences = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          FutureBuilder(
            future: userProvider.getUserVolunteer(userPreferences.getEmail()),
            builder: ((context, AsyncSnapshot<UserVolunteer> snapshot) {
              if (snapshot.hasData) {
                return Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: _screenSize.height * 0.08,
                        ),
                        // ElevatedButton(
                        //   child: Text("Lugares Favoritos"),
                        //   onPressed: (){Utils.homeNavigator.currentState.pushNamed(routeHomeFavoriteDepartmentsPage);},),
                        _formGroup("Nombre", snapshot.data.firstName),
                        _formGroup("Apellido", snapshot.data.lastName),
                        _formGroup("Correo", snapshot.data.email),
                        _formGroup("DNI", snapshot.data.dni),
                        _formGroup(
                            "Fecha de nacimiento",
                            DateTime.parse(snapshot.data.birthDate)
                                .toIso8601String()),
                        _formGroup(
                            "Género",
                            snapshot.data.genre == 0
                                ? 'Femenino'
                                : 'Mastulino'),
                        _formGroup("Experiencia",
                            snapshot.data.experience == 0 ? 'No' : 'Si'),
                      ],
                    ));
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error),
                  );
                } else {
                  return Center(
                    child: Text("Cargando Perfil"),
                  );
                }
              }
            }),
          ),
          Expanded(child: SizedBox()),
          ElevatedButton(
            child: Text("Cerrar Sesión"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () {
              final futures = <Future>[];

              final _prefs = UserPreferences();
              futures.add(_prefs.removeToken());
              futures.add(_prefs.removeUserId());
              futures.add(_prefs.removeEmail());

              Future.wait(futures).then((value) {
                Utils.mainNavigator.currentState
                    .pushReplacementNamed(routeLogin);
              });
            },
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    ));
  }

  Widget _formGroup(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17)),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
