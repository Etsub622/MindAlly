import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/util/get_token.dart';
import 'package:front_end/core/util/get_user_credential.dart';
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
        final userData = await getUserCredential();
        final token = await getToken();
        final patientId = userData?['_id'];
        String? profileImage;
        if(patient.profilePictureFile != null){
          final url = Uri.parse('https://api.cloudinary.com/v1_1/dzfbycabj/upload');
          final request = http.MultipartRequest('POST', url)
            ..fields['upload_preset'] = 'imagePreset'
            ..files.add(await http.MultipartFile.fromPath('file', patient.profilePictureFile!.path));
          final response = await request.send();

          if (response.statusCode == 200) {
            final responseData = await response.stream.toBytes();
            final responseString = String.fromCharCodes(responseData);
            final jsonMap = json.decode(responseString);
            profileImage = jsonMap['url'];
          } else {
            print('Failed to upload image');
          }
        }
        try{
          final Data = patient.toJson();
          Data["profilePicture"] = profileImage ?? patient.profilePicture;
          final reqBody = json.encode(Data);
          final response = await client.put(
              Uri.parse('$baseUrl/$patientId'),
              body: reqBody,
               headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);
          if(response.statusCode == 200){
               final responceData = json.decode(response.body);
                return UpdatePatientModel.fromJson(responceData['patient']);
            }else{
                throw ServerException(message:'Failed to update patient');
            }
          
        }catch(e){
          throw ServerException(message: "Error fetching patient");

        }
    }
   
      @override
      Future<Null> deletePatient({required String id}) async {
        final userData = await getUserCredential();
        final token = await getToken();
        final patientId = userData?['_id'];
       try{
          await client.delete(
            Uri.parse('$baseUrl/$patientId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            }
            );

        }catch(e){
          throw ServerException(message: "Error fetching patient");

        }

      }
}