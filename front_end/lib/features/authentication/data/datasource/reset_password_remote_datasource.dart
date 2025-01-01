import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/authentication/data/models/reset_password_model.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ResetPasswordRemoteDatasource {
  Future<String> resetPassword(ResetPasswordModel resetPassword);
}

class ResetPasswordRemoteImpl implements ResetPasswordRemoteDatasource {
  late final http.Client client;
  ResetPasswordRemoteImpl(this.client);
  final baseUrl = 'http://localhost:8000/api';

  @override
  Future<String> resetPassword(ResetPasswordModel resetPassword) async{
    try{
     var url = Uri.parse('$baseUrl/resetPassword');
      final user = await client.post(url,
          body: jsonEncode(resetPassword.toJson()),
          headers: {'Content-Type': 'application/json'});
      print(user.body);
      if (user.statusCode == 200) {
        return user.body;
      } else {
        throw ServerException(message: 'Failed to reset password');
      }

    }catch(e){
      throw ServerException(message: 'Unexpected error occured: ${e.toString()}');
    }
    
  }
}
