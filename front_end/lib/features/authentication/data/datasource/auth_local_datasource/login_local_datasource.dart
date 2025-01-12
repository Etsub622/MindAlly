import 'dart:convert';

import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginLocalDataSource {
  Future<void> cacheUser(String token);
  Future<StudentDataModel?> getUser();
  Future<void> deleteUser();
  Future<String> getToken();
  Future<void> setStudentUser(StudentDataModel studentDataModel);
}

const token_key = 'token_key';


class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final SharedPreferences sharedPreferences;

  LoginLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(String token)async {
     await sharedPreferences.setString(token_key, token);
  }

  @override
   Future<StudentDataModel?> getUser() async {
    final jsonString = sharedPreferences.getString(token_key);
    if (jsonString != null) {
      return StudentDataModel.fromJson(json.decode(jsonString));
    } else {
      throw Exception('No user data found in SharedPreferences');
    }
  }

  @override
  Future<void> deleteUser() {
    return sharedPreferences.remove(token_key);
  }

  @override
  Future<String> getToken() {
    return Future.value(sharedPreferences.getString(token_key) ?? '');
  }

  @override
  Future<void> setStudentUser(StudentDataModel studentDataModel) {
    return sharedPreferences.setString(token_key, json.encode(studentDataModel.toJson()));
  }
}