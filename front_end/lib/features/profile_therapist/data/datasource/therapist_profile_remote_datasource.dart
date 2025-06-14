import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/util/get_token.dart';
import 'package:front_end/core/util/get_user_credential.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
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
        String? profileImage;
        if(therapist.profilePictureFile != null){
          final url = Uri.parse('https://api.cloudinary.com/v1_1/dzfbycabj/upload');
          final request = http.MultipartRequest('POST', url)
            ..fields['upload_preset'] = 'imagePreset'
            ..files.add(await http.MultipartFile.fromPath('file', therapist.profilePictureFile!.path));
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
          final Data = therapist.toJson();
          Data["profilePicture"] = profileImage ?? therapist.profilePicture;
          final reqBody = json.encode(Data);
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
                throw ServerException(message:'Failed to load therapist');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }

    @override
    Future<Null> deleteTherapist({required String id}) async {
        try{
            final token = await getToken();
            final response = await client.delete(
              Uri.parse('$baseUrl/$id'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },);

            if( response.statusCode == 200){
              return Future.value(null);
            }else{
                throw Exception('Failed to delete account');
            }
        } catch(e){
            throw ServerException(message: 'Failed to load therapist');
        }
    }
    
}