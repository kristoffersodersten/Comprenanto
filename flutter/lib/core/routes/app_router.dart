import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import '../../pages/unknown_page.dart';
import 'app_page_route.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return AppPageRoute(
          page: HomePage(),
          settings: settings,
        );
      default:
        return AppPageRoute(
          page: UnknownPage(),
          settings: settings,
        );
    }
  }
}

final AppRouter appRouter = AppRouter();
