import 'package:front_end/features/calendar/domain/entity/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.userId,
    required super.therapistId,
    required super.meetingId,
    required super.meetingToken,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      userId: json['userId'],
      therapistId: json['therapistId'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      meetingId: json['meeting_id'],
      meetingToken: json['meeting_token'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'therapistId': therapistId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'meeting_token': meetingToken,
      'meeting_id': meetingId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}