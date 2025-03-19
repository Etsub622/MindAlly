import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString('token_key') ?? '';
}