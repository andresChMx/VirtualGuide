import 'dart:developer';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide/data/datasource/userPreferences.dart';
import 'package:tour_guide/data/entities/Project.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/data/providers/projectProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';
import 'package:tour_guide/ui/widgets/FlipCardWidget.dart';

class ExperienceDetails extends StatefulWidget {
  const ExperienceDetails({Key key}) : super(key: key);

  @override
  _ExperienceDetailState createState() => _ExperienceDetailState();
}

class _ExperienceDetailState extends State<ExperienceDetails> {
  Future<Project> futureProjectDetails;
  ProjectProvider projectProvider;

  final userPreferences = new UserPreferences();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Project project = ModalRoute.of(context)
        .settings
        .arguments; // error when trying to retrieve the argument passed to this widget from the initState method, thats why it is being done in this weird method

    futureProjectDetails = ProjectProvider().getProjectDetails(
        project.id.toString(), userPreferences.getUserId().toString());

    projectProvider = ProjectProvider();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final placesBloc = Provider.placesBlocOf(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black26),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: _buildContent(context, placesBloc)),
        )
        // body: FutureBuilder(
        //   future: Future,
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     if(snapshot.hasData){
        //       Container(padding:EdgeInsets.only(top:statusBarHeight) ,
        //         child:Column(
        //           children: [
        //             _buildCarousel()
        //           ],
        //         )
        //       );
        //     }else{
        //       return Container(
        //         child:Center(child: CircularProgressIndicator(),),
        //       );
        //     }
        //   },
        // ),
        );
  }

  Widget _buildContent(BuildContext context, PlacesBloc placesBloc) {
    return FutureBuilder(
      future: futureProjectDetails,
      builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
        if (snapshot.hasData) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            _buildCarousel(context, snapshot.data),
            _buildDetails(context, snapshot.data)
          ]);
        } else if (snapshot.hasError) {
          if (snapshot.error == '401') {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          } else {
            Future.delayed(
                Duration.zero, () => Utils.homeNavigator.currentState.pop());
          }
          return Container();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCarousel(BuildContext context, Project projectDetails) {
    return SizedBox(
        width: double.infinity,
        height: 400,
        child: projectDetails.photoUrls.length > 0
            ? Carousel(
                images: projectDetails.photoUrls
                    .map((item) => NetworkImage(item))
                    .toList())
            : Image(image: AssetImage("assets/img/no-image.jpg")));
  }

  Widget _buildDetails(BuildContext context, Project projectDetails) {
    final info = _section(projectDetails.name, () {
      return Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          projectDetails.description,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ));
    });

    // final more = _section("Descubre m??s de ...", () {
    //   return _slider(experienceDetails.categories.length, 0.6, 110,
    //       (context, i) {
    //     return Container(
    //       padding: EdgeInsets.all(20),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Flexible(
    //               fit: FlexFit.tight,
    //               child: Text(experienceDetails.categories[i].name,
    //                   style: TextStyle(fontSize: 24))),
    //           //Flexible(fit: FlexFit.tight, child: SizedBox()),
    //           //Flexible(fit: FlexFit.tight, child: Text(experienceDetails.categories[i].nExperiences.toString() + " experiencias",style:TextStyle(fontSize:17,color:Colors.black87)))
    //         ],
    //       ),
    //     );
    //   });
    // });
    final location = _section("Donde estar??s", () {
      final double lat = projectDetails.lat;
      final double lng = projectDetails.lng;
      return Container(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: GoogleMap(
            markers: Set<Marker>.of([
              Marker(
                  markerId: MarkerId('1'),
                  draggable: false,
                  visible: true,
                  position: LatLng(lat, lng))
            ]),
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(lat, lng), zoom: 11.5),
          ),
        ),
      );
    });
    // final reviews = _section(
    //     "${experienceDetails.avgRanking} (${experienceDetails.numberComments} comentarios)",
    //     () {
    //   return _slider(experienceDetails.reviews.length, 0.7, 250, (context, i) {
    //     return Container(
    //       padding: EdgeInsets.all(15),
    //       child: Column(
    //         children: [
    //           Row(
    //             children: [
    //               CircleAvatar(
    //                 child: Icon(Icons.account_box),
    //                 radius: 28,
    //               ),
    //               SizedBox(
    //                 width: 10,
    //               ),
    //               Container(
    //                   height: 56,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         experienceDetails.reviews[i].userName,
    //                         style: TextStyle(fontSize: 20),
    //                       ),
    //                       SizedBox(height: 5),
    //                       Text(experienceDetails.reviews[i].date,
    //                           style: TextStyle(
    //                               fontSize: 17, color: Colors.black54))
    //                     ],
    //                   ))
    //             ],
    //           ),
    //           SizedBox(
    //             height: 15,
    //           ),
    //           Flexible(
    //               fit: FlexFit.loose,
    //               child: Text(experienceDetails.reviews[i].comment))
    //         ],
    //       ),
    //     );
    //   });
    // });
    final buttonPostulate = _section("_______________", () {
      return Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber)),
          child: projectDetails.volunteerApplicationId != null
              ? Text("Cancelar Postulaci??n", style: TextStyle(fontSize: 18))
              : Text("Postular", style: TextStyle(fontSize: 18)),
          onPressed: () async {
            if (projectDetails.volunteerApplicationId == null) {
              projectProvider
                  .postPostulate(userPreferences.getUserId(), projectDetails.id)
                  .then((value) {
                log("hola");
                log(value.toString());
                projectDetails.volunteerApplicationId =
                    int.parse(value["id_application"]); //dummy application id
                setState(() {});
              });
            } else {
              projectProvider
                  .deletePostulation(
                      projectDetails.volunteerApplicationId.toString())
                  .then((value) {
                projectDetails.volunteerApplicationId = null;
                setState(() {});
              });
            }
          },
        ),
      ));
    });
    Widget similarExperiences = FutureBuilder(
      future: ProjectProvider()
          .getProjectsByOng(projectDetails.ongId.id, projectDetails.id),
      builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          return _section("Experiencias similaress", () {
            return _slider(snapshot.data.length, 0.45, 250, (context, i) {
              return FlipCard(
                project: snapshot.data[i],
                onTap: () {},
              );
            });
          });
        } else {
          return _section("Experiencias similares", () {
            return _slider(2, 0.45, 250, (context, i) {
              final Project experience = Project(
                id: 1,
                name: "Machupicchu",
                creationDate: DateTime.now(),
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",
                photoUrls: [
                  "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908103/taller-desempe%C3%B1o-profesional/pyjoctif663ddfqn8og6.jpg"
                ],
              );
              return FlipCard(
                project: experience,
                onTap: () {},
              );
            });
          });
        }
      },
    );

    // if (experienceDetails.similarExperience != null) {
    //   similarExperiences = _section("Experiencias similaress", () {
    //     return _slider(experienceDetails.similarExperience.length, 0.45, 250,
    //         (context, i) {
    //       final Experience experience = Experience(
    //           id: experienceDetails.similarExperience[i].id,
    //           name: experienceDetails.similarExperience[i].name,
    //           shortInfo: experienceDetails.similarExperience[i].shortInfo,
    //           picture: experienceDetails.similarExperience[i].pic,
    //           avgRanking: experienceDetails.similarExperience[i].avgRanking,
    //           nComments: experienceDetails.similarExperience[i].numberComments,
    //           province: experienceDetails.similarExperience[i].province,
    //           isFavorite: false);
    //       return FlipCard(
    //         experience: experience,
    //         onTap: () {},
    //       );
    //     });
    //   });
    // } else {
    //   similarExperiences = _section("Experiencias similares", () {
    //     return _slider(2, 0.45, 250, (context, i) {
    //       final Experience experience = Experience(
    //           id: 1,
    //           name: "Machupicchu",
    //           shortInfo:
    //               "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",
    //           picture:
    //               "https://res.cloudinary.com/djtqhafqe/image/upload/v1624908103/taller-desempe%C3%B1o-profesional/pyjoctif663ddfqn8og6.jpg",
    //           isFavorite: false);
    //       return FlipCard(
    //         experience: experience,
    //         onTap: () {},
    //       );
    //     });
    //   });
    // }

    return Container(
      color: Color.fromRGBO(79, 77, 140, 1),
      child: Column(
          children: [info, location, buttonPostulate, similarExperiences]),
    );
  }

  Widget _section(String title, Function body) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 15,
            ),
            body()
          ],
        ));
  }

  Widget _slider(int itemCount, double viewportFraction, double height,
      Function itemBuilder) {
    final _pageController =
        new PageController(initialPage: 1, viewportFraction: viewportFraction);
    return Container(
      width: double.infinity,
      height: height,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        itemCount: itemCount,
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.only(right: 8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                      color: Colors.white, child: itemBuilder(context, i))));
        },
      ),
    );
  }
}
