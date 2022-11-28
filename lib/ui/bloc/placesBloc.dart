import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:tour_guide/data/entities/Project.dart';
import 'package:tour_guide/data/entities/experience.dart';
import 'package:tour_guide/data/entities/experienceDetailed.dart';
import 'package:tour_guide/data/providers/experienceProvider.dart';
import 'package:tour_guide/data/providers/placesProvider.dart';
import 'package:tour_guide/data/providers/projectProvider.dart';

class PlacesBloc {
  PlacesProvider placesProvider = PlacesProvider();
  ExperienceProvider experienceProvider = ExperienceProvider();
  ProjectProvider projectProvider = ProjectProvider();

  BehaviorSubject<List<dynamic>> _searchResultsController =
      BehaviorSubject<List<dynamic>>();
  Stream<List<dynamic>> get searchResultStream =>
      _searchResultsController.stream;
  Function get changeSearchResult => _searchResultsController.sink.add;
  List<dynamic> get searchResult => _searchResultsController.value;

  BehaviorSubject<List<Experience>> _experiencesController =
      BehaviorSubject<List<Experience>>();
  Stream<List<Experience>> get experiencesStream =>
      _experiencesController.stream;
  Function get changeExperiences => _experiencesController.sink.add;
  List<Experience> get experiences => _experiencesController.value;

  BehaviorSubject<List<Project>> _projectController =
      BehaviorSubject<List<Project>>();
  Stream<List<Project>> get projectsStream => _projectController.stream;
  Function get changeProject => _projectController.sink.add;
  List<Project> get projects => _projectController.value;

  void getLocations(String term) async {
    final results = await placesProvider.getLocations(term);
    changeSearchResult(results);
  }

  Future<Map> getLocationDetail(String placeId) async {
    final Map locationDetail = await placesProvider.getLocationDetail(placeId);
    return locationDetail;
  }

  void getNearbyProjects(double lat, double long) async {
    final List<Project> projects =
        await projectProvider.getNearbyProjects(lat, long);
    changeProject(projects);
    print("Proyectos encontrados -> " + projects.length.toString());
  }

//-----------------------------------------------------------
  void getExperiences(String userId, double lat, double long) async {
    final List<Experience> experiences =
        await _getExperiences(userId, lat, long);
    changeExperiences(experiences);
    print("Experiencas encontradas -> " + experiences.length.toString());
  }

  void postAddFavoriteExperience(String experienceId) async {
    await experienceProvider.postAddFavoriteExperience(experienceId);
  }

  Future<List<Experience>> _getExperiences(
      String userId, double lat, double lng) async {
    final List<Experience> experiences =
        await experienceProvider.getExperiences(userId, lat, lng);
    return experiences;
  }

  Future<ExperienceDetailed> getExperienceDetail(String experienceId) async {
    try {
      return await experienceProvider.getExperienceDetail(experienceId);
    } catch (e) {
      return Future.error(e);
    }
  }

  void dispose() {
    _searchResultsController?.close();
    _experiencesController?.close();
    _projectController?.close();
  }
}
