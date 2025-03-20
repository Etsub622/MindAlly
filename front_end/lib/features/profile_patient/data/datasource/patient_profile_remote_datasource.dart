import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/profile_patient/data/models/patient_model.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';
import 'package:http/http.dart' as http;

abstract class PatientProfileRemoteDatasource {
    Future<PatientModel> getPatient({required String id});
    Future<UpdatePatientModel> updatePatient({required UpdatePatientModel patient});
    Future<Null> deletePatient({required String id});
}


class PatientProfileRemoteDatasourceImpl extends PatientProfileRemoteDatasource {
   late final http.Client client;
   
  PatientProfileRemoteDatasourceImpl({required this.client});
  final baseUrl = '${ConfigKey.baseUrl}/patients';
  
    @override
    Future<PatientModel> getPatient({required String id}) async {
         try{
            final response = await client.get(
              Uri.parse('$baseUrl/$id'),
              headers: {
                'Content-Type': 'application/json',
              },);

            if(response.statusCode == 200){
               final responceData = json.decode(response.body);
                return PatientModel.fromJson(responceData);
            }else{
                throw Exception('Failed to load therapist');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }

    @override
    Future<UpdatePatientModel> updatePatient({required UpdatePatientModel patient}) async {
        try{
          final response = await client.put(Uri.parse('$baseUrl'));
          final responseData = json.decode(response.body);
          return UpdatePatientModel.fromJson(responseData);
          
        }catch(e){
          throw ServerException(message: "Error fetching patient");

        }
    }
   
      @override
      Future<Null> deletePatient({required String id}) async {
    try{
          final response = await client.get(Uri.parse('$baseUrl'));
        }catch(e){
          throw ServerException(message: "Error fetching patient");

        }

      }
}