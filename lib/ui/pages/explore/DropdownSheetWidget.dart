import 'package:flutter/material.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/Application.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/providers/applicationProvider.dart';
import 'package:tour_guide/main.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/FlipCardWidget.dart';

class DropdownSheet extends StatelessWidget {
  ApplicationProvider provider = ApplicationProvider();
  UserPreferences preferences = UserPreferences();
  DropdownSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          color: Color.fromRGBO(79, 77, 140, 1),
        ),
        height: MediaQuery.of(context).size.height - 100.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 20,
              child: Center(
                child: Container(
                  width: 100,
                  height: 3,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: 30,
                child: Center(
                    child: Text("Postulaciones",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)))),
            SizedBox(height: 10),
            FutureBuilder(
                future: provider.getApplicationByUser(preferences.getUserId()),
                builder: (context, AsyncSnapshot<List<Application>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length <= 0) {
                      return Center(
                        child: Text("Aun no tienes postulaciones"),
                      );
                    } else {
                      return Column(
                          children: snapshot.data.map((application) {
                        return Row(
                          children: [
                            Text(application.project.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    color: Colors.white)),
                            ElevatedButton(
                              child: Text(
                                  application.status == 0
                                      ? 'Pendiente'
                                      : 'Aceptado',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white)),
                            )
                          ],
                        );
                      }).toList());
                    }
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error),
                      );
                    } else {
                      return Center(
                        child: Text("Cargando postulaciones"),
                      );
                    }
                  }
                })
            // Flexible(
            //   child:GridView.count(
            //   crossAxisCount: 2,
            //   mainAxisSpacing: 20.0,

            //   children: _buildExperiences(context)
            // ),
            // )
          ],
        ));
  }
  // List<Widget> _buildExperiences(context){
  //   return experiences.map((item){
  //     return FlipCard(
  //       project:item,
  //       horizontalPadding: 10,
  //       onTap: (){
  //         Utils.homeNavigator.currentState.pushNamed(routeHomeExperienceDetailsPage, arguments: item );
  //       },
  //     );
  //   }).toList();
  // }
}
