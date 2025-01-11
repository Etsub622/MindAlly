// import 'dart:async';

import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/core/routes/route_pattern.dart';

class RouteMatcher {
  final List<RoutePattern> patterns;

  RouteMatcher(List<String> patternStrings)
      : patterns = patternStrings.map((p) => RoutePattern(p)).toList();

  Map<String, dynamic>? match(String url) {
    final decodedUrl = Uri.decodeFull(url);

    for (var routePattern in patterns) {
      final match = routePattern.regex.firstMatch(decodedUrl);
      if (match != null) {
        return {
          'pattern': routePattern.pattern,
          'params': match.groupNames.fold<Map<String, String>>({}, (map, name) {
            map[name] = match.namedGroup(name)!;
            return map;
          })
        };
      }
    }

    return null;
  }
}

final authRouterMatcher = RouteMatcher(authRoutes);
final protectedRouterMatcher = RouteMatcher(protectedRoutes);
final allAvailableRouterMatcher =
    RouteMatcher([...authRoutes, ...protectedRoutes, ...publicRoutes]);