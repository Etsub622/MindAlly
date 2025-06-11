import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/util/get_user_credential.dart';
import 'package:front_end/features/calendar/data/model/event_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


abstract class EventScheduleRemoteDataSource {
  Future<List<EventModel>> getEventSchedules();
  Future<EventModel> addEventSchedule(EventModel event);
  Future<bool> updateEventSchedule(String sessionId);
  Future<bool> deleteEventSchedule(String sessionId);

}

class EventScheduleRemoteDataSourceImpl implements EventScheduleRemoteDataSource {
  final http.Client client;

  EventScheduleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<EventModel>> getEventSchedules() async {
    final userProfile = await getUserCredential();
    
    final role = userProfile != null ? userProfile["Role"] : "" ;
    final userId = userProfile != null ? userProfile["_id"]?.toString() : "";
    
    const  baseUrl = '${ConfigKey.baseUrl}/schedule';

    final String endpoint = role == 'patient'
        ? '$baseUrl/user/$userId/sessions'
        : '$baseUrl/therapist/$userId';

    try {
      final response = await client.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'Network error: $e');
    }
  }
  @override
  Future<EventModel> addEventSchedule(EventModel event) async {
    const String endpoint = 'http://10.0.2.2:8000/api/schedule/book';

    try {
      final response = await client.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': event.patientId,
          'therapistId': event.therapistId,
          'createrId':event.createrId,
          'date': event.date,
          'startTime': event.startTime,
          'endTime': event.endTime,
          'meeting_id':event.meetingId,
          "meeting_token": event.meetingToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return EventModel.fromJson(jsonResponse['session']);
      } else {
        throw ServerException(message: 'Failed to   session: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'Network error: $e');
    }
  }

   @override
  Future<bool> updateEventSchedule(String sessionId) async {
    String endpoint = 'http://10.0.2.2:8000/api/schedule/$sessionId/confirm';

    try {
      final response = await client.patch(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ServerException(message: 'Failed to   session: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'Network error: $e');
    }
  }

   @override
  Future<bool> deleteEventSchedule(String  sessionId) async {
    String endpoint = 'http://10.0.2.2:8000/api/schedule/$sessionId/cancel';

    try {
      final response = await client.patch(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ServerException(message: 'Failed to cancel session: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: 'Network error: $e');
    }
  }
}