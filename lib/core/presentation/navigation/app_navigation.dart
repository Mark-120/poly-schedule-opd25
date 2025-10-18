import 'package:flutter/material.dart';

import '../../../presentation/pages/building_search_screen.dart';
import '../../../presentation/pages/class_search_screen.dart';
import '../../../presentation/pages/empty_schedule_screen.dart';
import '../../../presentation/pages/featured_screen.dart';
import '../../../presentation/pages/schedule_screen.dart';
import '../../../presentation/pages/search_screen.dart';

class AppNavigation {
  static Route<dynamic>? onGeneretaRoute(RouteSettings settings) {
    if (settings.name == BuildingSearchScreen.route) {
      final args = settings.arguments as BuildingSearchScreenArguments;
      return MaterialPageRoute(
        builder: (context) => BuildingSearchScreen(onSaveRoom: args.onSaveRoom),
      );
    }
    if (settings.name == ClassSearchScreen.route) {
      final args = settings.arguments as ClassSearchScreenArguments;
      return MaterialPageRoute(
        builder:
            (context) => ClassSearchScreen(
              buildingId: args.buildingId,
              onSaveRoom: args.onSaveRoom,
            ),
      );
    }
    if (settings.name == ScheduleScreen.route) {
      final args = settings.arguments as ScheduleScreenArguments;
      return MaterialPageRoute(
        builder:
            (context) => ScheduleScreen(
              id: args.id,
              dayTime: args.dayTime,
              bottomTitle: args.bottomTitle,
            ),
      );
    }
    if (settings.name == SearchScreen.route) {
      final args = settings.arguments as SearchScreenArguments;
      return args.searchScreenType == SearchScreenType.groups
          ? MaterialPageRoute(
            builder:
                (context) =>
                    SearchScreen.groups(onSaveGroup: args.onSaveGroup!),
          )
          : MaterialPageRoute(
            builder:
                (context) =>
                    SearchScreen.teachers(onSaveTeacher: args.onSaveTeacher!),
          );
    }
    return null;
  }

  static final routes = {
    EmptyScheduleScreen.route: (context) => EmptyScheduleScreen(),
    FeaturedScreen.route: (context) => FeaturedScreen(),
  };
}
