 import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/error/exception.dart';

@override
  Future<Map<String, dynamic>?> getUserCredential() async {
    const  flutterSecureStorage = FlutterSecureStorage();
    final userCredential = await flutterSecureStorage.read(key: 'user_profile');

    if (userCredential != null) {
      final body = await json.decode(userCredential);
      return body;
    } else {
      throw CacheException(message: "User not found");
    }
  }