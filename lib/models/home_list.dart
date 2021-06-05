import 'package:flutter/widgets.dart';
import 'package:management_of_scientific_research_project_of_ptithcm/screens/main_screen/notifications_screen.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
    HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
    HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
     HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
     HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
     HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
     HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
     HomeList(
      imagePath: 'assets/images/research-techniques.jpg',
      navigateScreen: NotificationScreen(),
    ),
  ];
}
