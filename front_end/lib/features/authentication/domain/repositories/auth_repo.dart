import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/login_entity.dart';
import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';
import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';
import 'package:front_end/features/authentication/presentation/screens/professional_signUp.dart';
import 'package:front_end/features/authentication/presentation/screens/student_signUp.dart';
import 'package:dartz/dartz.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> studentSignUp(
      StudentSignupEntity studentSignUp);
  Future<Either<Failure, String>> professionalSignup(
      ProfessionalSignupEntity professionalSignup);
  Future<Either<Failure, StudentResponseModel>> login(LoginEntity login);
  Future<Either<Failure, String>> sendOtp(String email);
  Future<Either<Failure, String>> verifyOtp(String otp,String email);
}
