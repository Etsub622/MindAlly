import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String userId;
  final String therapistId;
  final String date;
  final String timeSlot;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventEntity({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Compute startTime for DateTimePicker compatibility
  DateTime get startTime {
    final dateParts = date.split('-').map(int.parse).toList();
    final timeParts = timeSlot.split(':').map(int.parse).toList();
    return DateTime(
      dateParts[0], // year
      dateParts[1], // month
      dateParts[2], // day
      timeParts[0], // hour
      timeParts[1], // minute
    );
  }

  @override
  List<Object?> get props => [id, userId, therapistId, date, timeSlot, status, createdAt, updatedAt];
}