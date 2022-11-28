import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/Project.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:tour_guide/ui/routes/routes.dart';

import '../../../main.dart';

class ExperiencesCarousel extends StatefulWidget {
  final List<Project> projects;

  ExperiencesCarousel({@required this.projects});

  @override
  _ExperiencesCarouselState createState() => _ExperiencesCarouselState();
}

class _ExperiencesCarouselState extends State<ExperiencesCarousel> {
  final _pageController =
      new PageController(initialPage: 0, viewportFraction: 0.9);
  final ExperienceProvider experienceProvider = ExperienceProvider();
  @override
  Widget build(BuildContext context) {
    final placesBloc = Provider.placesBlocOf(context);
    final numberCards = widget.projects.length;
    return Container(
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: numberCards > 5 ? 5 : numberCards,
        itemBuilder: (context, i) {
          return _tarjeta(context, widget.projects[i], placesBloc);
        },
      ),
    );
  }

  Widget _tarjeta(
      BuildContext context, Project experience, PlacesBloc placesBloc) {
    final tarjeta = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black45),
          color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage(
                      image: Utils.getPosterImage(
                          experience.photoUrls.length > 0
                              ? experience.photoUrls[0]
                              : "https://s.com"),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      fit: BoxFit.cover,
                      height: 100.0,
                      width: 120.0,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),

                Flexible(
                  child: OverflowBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience.name,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${experience.description}",
                          style: TextStyle(fontSize: 13),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.grey[800],
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${experience.cantApplications}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                        // Row(children: [
                        //   Icon(
                        //     Icons.star_rate,
                        //     color: Colors.orangeAccent,
                        //   ),
                        //   Flexible(
                        //       child: Text(
                        //     "${experience.ongId.name} (${experience.creationDate}). ${experience.location}",
                        //     style: TextStyle(fontSize: 16),
                        //     overflow: TextOverflow.ellipsis,
                        //   ))
                        // ]),
                      ],
                    ),
                  ),
                )
                // Text(
                //   pelicula.title,
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context).textTheme.caption,
                // )
              ],
            ),
          ),
          // Positioned(
          //   right:4,
          //   top:4,
          //   child: GestureDetector(
          //     onTap: (){
          //       // experience.isFavorite=!experience.isFavorite;
          //         if(!experience.isFavorite){
          //           placesBloc.postAddFavoriteExperience(experience.id.toString());
          //           experience.isFavorite=true;
          //           setState(() {});
          //         }
          //     },
          //     child: experience.isFavorite?Icon(Icons.favorite):Icon(Icons.favorite_border),
          //   ),
          // )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Utils.homeNavigator.currentState
            .pushNamed(routeHomeExperienceDetailsPage, arguments: experience);
      },
    );
  }
}
