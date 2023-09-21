import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:foda_admin/repositories/user_repository.dart';
import 'package:foda_admin/screens/dashboard/dashboard_view.dart';
import 'package:foda_admin/services/navigation_service.dart';

import 'constant/route_name.dart';
import 'services/get_it.dart';

class UrlHandlerRouterDelegate extends RouterDelegate<String> {
  final userRepository = locate<UserRepository>();
  final navigationService = locate<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return DashboardView(currentPath: navigationService.determineHomePath());
  }

  @override
  void addListener(html.VoidCallback listener) {}

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  void removeListener(html.VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(configuration) async {
    if (userRepository.currentUserUID != null && configuration != authPath) {
      if (!navigationService.pathToCloseNavigationBar.contains(configuration)) {
        navigationService.setNavigationBar = true;
      }
      navigationService.routeNotifier.value = configuration;
      navigatePushReplaceName(configuration);
    } else {
      if (userRepository.currentUserUID == null) {
        navigatePushReplaceName(authPath);
      } else {
        navigatePushReplaceName(overview);
      }
    }
  }
}

class UrlHandlerInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    return "${routeInformation.location}";
  }
}
