import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/util/get_token.dart';
import 'package:front_end/core/util/get_user_credential.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:http/http.dart' as http;

abstract class TherapistProfileRemoteDatasource {
    Future<TherapistModel> getTherapist({required String id});
    Future<TherapistModel> createTherapist({required TherapistModel therapist});
    Future<UpdateTherapistModel> updateTherapist({required UpdateTherapistModel therapist});
    Future<Null> deleteTherapist({required String id});
}


class TherapistProfileRemoteDatasourceImpl extends TherapistProfileRemoteDatasource {
   late final http.Client client;
   
  TherapistProfileRemoteDatasourceImpl({required this.client});
    final baseUrl = '${ConfigKey.baseUrl}/therapists';

    @override
    Future<TherapistModel> getTherapist({required String id}) async {
        try{
            final response = await client.get(
              Uri.parse('$baseUrl/$id'),
              headers: {
                'Content-Type': 'application/json',
              },);

            if(response.statusCode == 200){
               final responceData = json.decode(response.body);
                return TherapistModel.fromJson(responceData);
            }else{
                throw Exception('Failed to load therapist');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }

    @override
    Future<TherapistModel> createTherapist({required TherapistModel therapist}) async {
        try{
            final response = await client.post(
              Uri.parse('$baseUrl/${therapist.id}'),
              body: json.encode(therapist.toJson()),
              headers: {
                'Content-Type': 'application/json',
              },);

            if(response.statusCode == 200){
               final responceData = json.decode(response.body);
                return TherapistModel.fromJson(responceData);
            }else{
                throw Exception('Failed to load therapist');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }

    @override
    Future<UpdateTherapistModel> updateTherapist({required UpdateTherapistModel therapist}) async {
        final userData = await getUserCredential();
        final token = await getToken();
        final therapistId = userData?['_id'];
        try{
          final reqBody = json.encode(therapist.toJson());
            final response = await client.put(
              Uri.parse('$baseUrl/$therapistId'),
              body: reqBody,
               headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);

            if(response.statusCode == 200){
               final responceData = json.decode(response.body);
                return UpdateTherapistModel.fromJson(responceData);
            }else{
                throw Exception('Failed to load therapist');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }

    @override
    Future<Null> deleteTherapist({required String id}) {
        // Implement the logic to delete a therapist
        throw UnimplementedError();
    }
    
}