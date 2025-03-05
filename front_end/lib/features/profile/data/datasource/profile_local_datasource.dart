import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';


abstract class ProfileLocalDataSource {
  Future<StudentDataModel> getUserCredential();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  ProfileLocalDataSourceImpl({required this.flutterSecureStorage});

  final String authenticationKey = "access_token";
  final String userProfileKey = "user_profile";

  @override
  Future<StudentDataModel> getUserCredential() async {
    final userCredential = await flutterSecureStorage.read(key: userProfileKey);

    if (userCredential != null) {
      final body = await json.decode(userCredential);

      final res = StudentDataModel.fromJson(body);

      return res;
    } else {
      throw CacheException(message: "User not found");
    }
  }

}

