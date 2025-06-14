import 'package:front_end/features/calendar/domain/entity/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.patientId,
    required super.therapistId,
    required super.meetingId,
    required super.createrId,
    required super.meetingToken,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.price,
    super.patientCheckInTimes = const [],
    super.patientCheckOutTimes = const [],
    super.therapistCheckInTimes = const [],
    super.therapistCheckOutTimes = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      patientId: json['userId'],
      therapistId: json['therapistId'],
      createrId:json['createrId'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      meetingId: json['meeting_id'],
      meetingToken: json['meeting_token'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      price: json['price']?.toDouble() ?? 0.0,
      patientCheckInTimes: (json['patientCheckInTimes'] as List<dynamic>?)?.map((e) => {
            'index': e['index'],
            'time': DateTime.parse(e['time']),
          }).toList() ?? [],
      patientCheckOutTimes: (json['patientCheckOutTimes'] as List<dynamic>?)?.map((e) => {
            'index': e['index'],
            'time': DateTime.parse(e['time']),
          }).toList() ?? [],
      therapistCheckInTimes: (json['therapistCheckInTimes'] as List<dynamic>?)?.map((e) => {
            'index': e['index'],
            'time': DateTime.parse(e['time']),
          }).toList() ?? [],
      therapistCheckOutTimes: (json['therapistCheckOutTimes'] as List<dynamic>?)?.map((e) => {
            'index': e['index'],
            'time': DateTime.parse(e['time']),
          }).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': patientId,
      'therapistId': therapistId,
      'createrId': createrId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'meeting_token': meetingToken,
      'meeting_id': meetingId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'price': price,
      'patientCheckInTimes': patientCheckInTimes.map((e) => {
            'index': e['index'],
            'time': e['time'].toIso8601String(),
          }).toList(),
      'patientCheckOutTimes': patientCheckOutTimes.map((e) => {
            'index': e['index'],
            'time': e['time'].toIso8601String(),
          }).toList(),
      'therapistCheckInTimes': therapistCheckInTimes.map((e) => {
            'index': e['index'],
            'time': e['time'].toIso8601String(),
          }).toList(),
      'therapistCheckOutTimes': therapistCheckOutTimes.map((e) => {
            'index': e['index'],
            'time': e['time'].toIso8601String(),
          }).toList(),
    };
  }
}