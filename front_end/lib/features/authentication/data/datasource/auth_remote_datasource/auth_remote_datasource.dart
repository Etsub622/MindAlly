import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/authentication/data/models/login_model.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AuthRemoteDatasource {
  Future<String> studentSignUp(StudentSignupModel studentModel);
  Future<String> professionalSignUp(ProfessionalSignupModel professionalModel);
  Future<String> logIn(LoginModel loginModel);
  Future<String> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String otp, String phoneNumber);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  late final http.Client client;
  AuthRemoteDatasourceImpl({required this.client});
  final baseUrl = 'http://localhost:8000/api';

  @override
  Future<String> professionalSignUp(
      ProfessionalSignupModel professionalModel) async {
    try {
      var url = Uri.parse('$baseUrl/therapist/Tsignup');
      final user = await client.post(url,
          body: jsonEncode(professionalModel.toJson()),
          headers: {'Content-Type': 'application/json'});
      print(user.body);
      if (user.statusCode == 200) {
        return user.body;
      } else {
        throw ServerException(message: 'Failed to sign up');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }

  @override
  Future<String> studentSignUp(StudentSignupModel studentModel) async {
    try {
      var url = Uri.parse('$baseUrl/patient/Psignup');
      final user = await client.post(url,
          body: jsonEncode(studentModel.toJson()),
          headers: {'Content-Type': 'application/json'});
      print(user.body);
      print(user.statusCode);
      if (user.statusCode == 200) {
        return user.body;
      } else {
        throw ServerException(message: 'Failed to sign up');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }

  @override
  Future<String> logIn(LoginModel loginModel) async {
    try {
      var url = Uri.parse('$baseUrl/login');
      final user = await client.post(url,
          body: jsonEncode(loginModel.toJson()),
          headers: {'Content-Type': 'application/json'});

      if (user.statusCode == 200) {
        return jsonDecode(user.body)['token'];
      } else {
        throw ServerException(message: 'Failed to sign up');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }

  @override
  Future<String> sendOtp(String phoneNumber) async {
    try {
      var url = Uri.parse('$baseUrl/sendOtp');
      final res = await client.post(url,
          body: jsonEncode({'phoneNumber': phoneNumber}),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (res.statusCode == 200) {
        return jsonDecode(res.body)['message'];
      } else {
        throw ServerException(message: 'Failed to send OTP');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }

  @override
  Future<String> verifyOtp(String otp, String phoneNumber) async {
    try {
      var url = Uri.parse('$baseUrl/verifyOtp');
      final res = await client.post(url,
          body: jsonEncode({'otp': otp, 'phoneNumber': phoneNumber}),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (res.statusCode == 200) {
        return jsonDecode(res.body)['message'];
      } else {
        throw ServerException(message: 'Failed to verify OTP');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }
}
