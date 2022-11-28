import 'package:flutter/material.dart';
import 'package:tour_guide/data/entities/Project.dart';
import 'dart:math';

import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/ui/bloc/placesBloc.dart';
import 'package:tour_guide/ui/bloc/provider.dart';
import 'package:tour_guide/ui/helpers/utils.dart';
import 'package:intl/intl.dart';

class FlipCard extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;
  final Project project;
  final double horizontalPadding;
  FlipCard(
      {@required this.project,
      this.horizontalPadding = 0,
      this.onTap,
      this.onLongPress,
      Key key})
      : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isBack = true;
  double angle = 0;

  final ExperienceProvider experienceProvider = ExperienceProvider();
  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final placesBloc = Provider.placesBlocOf(context);
    return GestureDetector(
      onTap: () {
        print("TAP ON THE MAIN DETECTOR");
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress();
        }
        _flip();
      },
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: Duration(milliseconds: 300),
          builder: (BuildContext context, double val, __) {
            //here we will change the isBack val so we can change the content of the card
            if (val >= (pi / 2)) {
              isBack = false;
            } else {
              isBack = true;
            }
            return (Transform(
              //let's make the card flip by it's center
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: Container(
                  child: isBack
                      ? _buildFrontFace(placesBloc)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(
                                pi), // it will flip horizontally the container
                          child:
                              _buildBackFace()) //else we will display it here,
                  ),
            ));
          }),
    );
  }

  Widget _buildFrontFace(PlacesBloc placesBloc) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage(
                    placeholder: AssetImage("assets/img/loading.gif"),
                    image: Utils.getPosterImage(
                        widget.project.photoUrls.length > 0
                            ? widget.project.photoUrls[0]
                            : "http://sdf.com"),
                    fit: BoxFit.fitHeight),
              ),
            ],
          ),
        ));
  }

  Widget _buildBackFace() {
    final TextStyle cardTitleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    final TextStyle cardDescriptionStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

    final Project project = widget.project;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage(
                    placeholder: AssetImage("assets/img/loading.gif"),
                    image: Utils.getPosterImage(project.photoUrls.length > 0
                        ? project.photoUrls[0]
                        : ""),
                    fit: BoxFit.fitHeight),
              ),
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(79, 77, 140, 0.5),
                  padding: EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.white70,
                            size: 20,
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                " ${DateFormat('yyyy-MM-dd').format(project.creationDate)}",
                                style: cardTitleStyle,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      )),
                      Expanded(child: SizedBox()),
                      Flexible(
                          child: Text(
                        project.name,
                        style: cardTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Expanded(child: SizedBox()),
                      Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: SingleChildScrollView(
                              child: Text(
                            project.description,
                            style: cardDescriptionStyle,
                            textAlign: TextAlign.center,
                          ))),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(Icons.arrow_circle_down_rounded,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
