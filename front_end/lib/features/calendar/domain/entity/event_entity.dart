import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String userId;
  final String therapistId;
  final String meetingId;
  final String meetingToken;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventEntity({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.date,
    required this.meetingId,
    required this.meetingToken,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });



  @override
  List<Object?> get props => [id, userId, therapistId, date, startTime, endTime, status, createdAt, updatedAt];
}