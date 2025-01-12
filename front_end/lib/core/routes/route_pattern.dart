// import 'dart:async';

class RoutePattern {
  final String pattern;
  final RegExp regex;

  RoutePattern(this.pattern) : regex = _createRegex(pattern);

  static RegExp _createRegex(String pattern) {
    final regexPattern = pattern.replaceAllMapped(
        RegExp(r':([^/]+)'), (match) => '(?<${match[1]}>[^/]+)');
    return RegExp('^' + regexPattern + r'$');
  }
}
