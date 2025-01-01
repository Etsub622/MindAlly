import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:front_end/features/authentication/data/models/login_model.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:front_end/features/authentication/domain/entities/login_entity.dart';
import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';
import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final NetworkInfo networkInfo;
  final LoginLocalDataSource loginLocalDataSource;
  AuthRepoImpl(
      this.authRemoteDatasource, this.networkInfo, this.loginLocalDataSource);

  @override
  Future<Either<Failure, StudentResponseModel>> login(LoginEntity login) async {
    if (await networkInfo.isConnected) {
      try {
        final user = LoginModel(
            id: login.id, email: login.email, password: login.password);
        final response = await authRemoteDatasource.logIn(user);

        await loginLocalDataSource
            .setStudentUser(response.studentData as StudentDataModel);
        await loginLocalDataSource.cacheUser(response.token);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> professionalSignup(
      ProfessionalSignupEntity professionalSignup) async {
    if (await networkInfo.isConnected) {
      try {
        final user = ProfessionalSignupModel(
            id: professionalSignup.id,
            email: professionalSignup.email,
            password: professionalSignup.password,
            fullName: professionalSignup.fullName,
            phoneNumber: professionalSignup.phoneNumber,
            specialization: professionalSignup.specialization,
            document: professionalSignup.document);
        final response = await authRemoteDatasource.professionalSignUp(user);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> studentSignUp(
      StudentSignupEntity studentSignUp) async {
    if (await networkInfo.isConnected) {
      try {
        final user = StudentSignupModel(
            id: studentSignUp.id,
            email: studentSignUp.email,
            password: studentSignUp.password,
            fullName: studentSignUp.fullName,
            phoneNumber: studentSignUp.phoneNumber,
            collage: studentSignUp.collage);
        final response = await authRemoteDatasource.studentSignUp(user);
        print(response);
        print('helllojkldjkljkag');
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await authRemoteDatasource.sendOtp(phoneNumber);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
      String otp, String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await authRemoteDatasource.verifyOtp(otp, phoneNumber);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }
}
