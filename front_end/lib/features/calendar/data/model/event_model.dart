import 'package:front_end/features/calendar/domain/entity/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.userId,
    required super.therapistId,
    required super.date,
    required super.timeSlot,
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
      timeSlot: json['timeSlot'],
      status: json['status'],
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
      'timeSlot': timeSlot,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}