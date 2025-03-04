import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDatasource {
    Future<PatientModel> getPatient({required String id});
    Future<PatientModel> createPatient({required PatientEntity patient});
    Future<PatientModel> updatePatient({required PatientEntity patient});
    Future<Null> deletePatient({required String id});

    Future<TherapistModel> getTherapist({required String id});
    Future<TherapistModel> createTherapist({required TherapistEntity therapist});
    Future<TherapistModel> updateTherapist({required TherapistEntity therapist});
    Future<Null> deleteTherapist({required String id});
}


class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
   late final http.Client client;
   
  ProfileRemoteDatasourceImpl({required this.client});
  final baseUrl = '${ConfigKey.baseUrl}/user';
    @override
    Future<PatientModel> getPatient({required String id}) {
        // Implement the logic to get a patient from the remote server
        throw UnimplementedError();
    }

    @override
    Future<PatientModel> createPatient({required PatientEntity patient}) {
        // Implement the logic to create a new patient
        throw UnimplementedError();
    }

    @override
    Future<PatientModel> updatePatient({required PatientEntity patient}) {
        // Implement the logic to update an existing patient
        throw UnimplementedError();
    }
   
      @override
      Future<Null> deletePatient({required String id}) {
    // TODO: implement deletePatient
    throw UnimplementedError();
      }
    @override
    Future<TherapistModel> getTherapist({required String id}) {
        // Implement the logic to get a therapist from the remote server
        throw UnimplementedError();
    }

    @override
    Future<TherapistModel> createTherapist({required TherapistEntity therapist}) {
        // Implement the logic to create a new therapist
        throw UnimplementedError();
    }

    @override
    Future<TherapistModel> updateTherapist({required TherapistEntity therapist}) {
        // Implement the logic to update an existing therapist
        throw UnimplementedError();
    }

    @override
    Future<Null> deleteTherapist({required String id}) {
        // Implement the logic to delete a therapist
        throw UnimplementedError();
    }
    
}