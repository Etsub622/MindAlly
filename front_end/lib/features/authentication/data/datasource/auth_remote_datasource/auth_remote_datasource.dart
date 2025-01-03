import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/models/login_model.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDatasource {
  Future<String> studentSignUp(StudentSignupModel studentModel);
  Future<String> professionalSignUp(ProfessionalSignupModel professionalModel);
  Future<StudentResponseModel> logIn(LoginModel loginModel);
  Future<String> sendOtp(String email);
  Future<String> verifyOtp(String otp, String email);
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
        final jsonResponse = jsonDecode(user.body);
        final token = jsonResponse['token'];

        // Save the token to SharedPreferences
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('token_key', token);

        return token;
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
      var url = Uri.parse('$baseUrl/patient/patientSignup');

      final user = await client.post(url,
          body: jsonEncode(studentModel.toJson()),
          headers: {'Content-Type': 'application/json'});
      print(user.body);
      print(user.statusCode);
      if (user.statusCode == 200) {
        final jsonResponse = jsonDecode(user.body);
        final token = jsonResponse['token'];

        // Save the token to SharedPreferences
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('token_key', token);

        return token;
      } else {
        throw ServerException(message: 'Failed to sign up');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occured: ${e.toString()}');
    }
  }

  @override
  Future<StudentResponseModel> logIn(LoginModel loginModel) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final loginLocalDataSource =
          LoginLocalDataSourceImpl(sharedPreferences: sharedPreferences);
      final token = await loginLocalDataSource.getToken();

      // Decode the token to get the role
      Map<String, dynamic> payload = JwtDecoder.decode(token);
      String role = payload['role'];

      var url;
      if (role == 'patient') {
        url = Uri.parse('$baseUrl/patient/patientLogin');
      } else if (role == 'therapist') {
        url = Uri.parse('$baseUrl/therapist/therapistLogin');
      }

      final user = await client.post(url,
          body: jsonEncode(loginModel.toJson()),
          headers: {'Content-Type': 'application/json'});

      if (user.statusCode == 200) {
        final responseJson = jsonDecode(user.body);

        if (responseJson['user'] == null) {
          throw ServerException(message: 'User data is null');
        }

        final studentResponse = StudentResponseModel.fromJson(responseJson);
        print(studentResponse);
        return studentResponse;
      } else {
        throw ServerException(message: 'Failed to sign up');
      }
    } catch (e) {
      throw ServerException(
          message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<String> sendOtp(String email) async {
    try {
      var url = Uri.parse('$baseUrl/otp/sendOtp');
      final res = await client.post(url,
          body: jsonEncode({'email': email}),
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
  Future<String> verifyOtp(String otp, String email) async {
    try {
      var url = Uri.parse('$baseUrl/otp/verifyOtp');
      final res = await client.post(url,
          body: jsonEncode({'otp': otp, 'email': email}),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print(res.statusCode);
      print('email: $email');
      print('otp: $otp');
      print(res.body);

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
