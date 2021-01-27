import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'designer.dart';
import 'models/app_state.dart';

const String designerRoute = '/designer/';

const String designerInterventionsRoute = '${designerRoute}interventions';
const String designerQuestionnaireRoute = '${designerRoute}questionnaire';
const String designerEligibilityRoute = '${designerRoute}eligibility';
const String designerObservationsRoute = '${designerRoute}observations';
const String designerScheduleRoute = '${designerRoute}schedule';
const String designerConsentRoute = '${designerRoute}consent';
const String designerReportRoute = '${designerRoute}report';
const String designerResultsRoute = '${designerRoute}results';
const String designerSaveRoute = '${designerRoute}save';

/// Transforms String to Enum value. Dart does not have support for this (yet)
T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split('.').last == value, orElse: () => null);
}

class RootRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == DesignerPath.basePath) {
      // Parses only with id /designer/:id and not /designer/
      if (uri.pathSegments.length == 2 && uri.pathSegments[1].isNotEmpty) {
        return DesignerPath(studyId: uri.pathSegments[1]);
      }
      // /designer/:id/:page
      if (uri.pathSegments.length == 3 && uri.pathSegments[1].isNotEmpty && uri.pathSegments[2].isNotEmpty) {
        return DesignerPath(
            studyId: uri.pathSegments[1], page: enumFromString<DesignerPage>(DesignerPage.values, uri.pathSegments[2]));
      }
      return DesignerPath();
    }
    return HomePath();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath configuration) {
    if (configuration is HomePath) {
      return RouteInformation(location: '/');
    }
    if (configuration is DesignerPath) {
      var designerLocation = '/${DesignerPath.basePath}';
      if (configuration.studyId != null) {
        designerLocation += '/${configuration.studyId}';
      }
      if (configuration.page != null) {
        designerLocation += '/${configuration.page.toString().split('.')[1]}';
      }
      return RouteInformation(location: designerLocation);
    }
    return null;
  }
}

class RootRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState appState;

  RootRouterDelegate(this.appState) : navigatorKey = GlobalObjectKey<NavigatorState>(appState) {
    appState.addListener(notifyListeners);
  }

  @override
  RoutePath get currentConfiguration {
    if (appState.isDesigner) {
      return DesignerPath(studyId: appState.selectedStudyId, page: appState.selectedDesignerPage);
    }
    return HomePath();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('Dashboard'),
          child: Dashboard(),
        ),
        if (appState.isDesigner)
          MaterialPage(
            key: ValueKey('Designer'),
            child: Designer(studyId: appState.selectedStudyId),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (appState.isDesigner) {
          appState.closeDesigner();
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    if (path is HomePath) {
      appState.closeDesigner();
    } else if (path is DesignerPath) {
      if (path.studyId != null) {
        appState.openStudy(path.studyId, page: path.page);
      } else {
        appState.createStudy();
      }
    }
  }
}

abstract class RoutePath {}

class HomePath implements RoutePath {}

class DesignerPath implements RoutePath {
  static const String basePath = 'designer';
  final DesignerPage page;
  final String studyId;

  DesignerPath({this.studyId, this.page = DesignerPage.about});
}
