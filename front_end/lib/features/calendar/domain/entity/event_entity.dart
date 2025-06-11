import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String patientId;
  final String therapistId;
  final String meetingId;
  final String createrId;
  final String meetingToken;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  double price;
  final List<dynamic> patientCheckInTimes;
  final List<dynamic> patientCheckOutTimes;
  final List<dynamic> therapistCheckInTimes;
  final List<dynamic> therapistCheckOutTimes;

  EventEntity({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.createrId,
    required this.date,
    required this.meetingId,
    required this.meetingToken,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    this.patientCheckInTimes = const [],
    this.patientCheckOutTimes = const [],
    this.therapistCheckInTimes = const [],
    this.therapistCheckOutTimes = const [],
  });

   EventEntity copyWith({
    String? id,
    String? patientId,
    String? therapistId,
    String? createrId,
    String? meetingId,
    String? meetingToken,
    String? date,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? price,
    List<Map<String, dynamic>>? patientCheckInTimes,
    List<Map<String, dynamic>>? patientCheckOutTimes,
    List<Map<String, dynamic>>? therapistCheckInTimes,
    List<Map<String, dynamic>>? therapistCheckOutTimes,
  }) {
    return EventEntity(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      therapistId: therapistId ?? this.therapistId,
      createrId: createrId ?? this.createrId,
      meetingId: meetingId ?? this.meetingId,
      meetingToken: meetingToken ?? this.meetingToken,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      price: price ?? this.price,
      patientCheckInTimes: patientCheckInTimes ?? this.patientCheckInTimes,
      patientCheckOutTimes: patientCheckOutTimes ?? this.patientCheckOutTimes,
      therapistCheckInTimes: therapistCheckInTimes ?? this.therapistCheckInTimes,
      therapistCheckOutTimes: therapistCheckOutTimes ?? this.therapistCheckOutTimes,
    );
  }



  @override
  List<Object?> get props => [id, patientId, therapistId,createrId, date, startTime, endTime, status, createdAt, updatedAt, price];
}