import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/delete_event/delete_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';
import 'package:front_end/features/payment/presentation/screens/payment_screen.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WaitingDialog extends StatefulWidget {
  final EventEntity event;
  final String userId;
  final bool isTherapist;
  final String? chatId;
  final String userEmail;

  const WaitingDialog({
    super.key,
    required this.event,
    required this.userId,
    required this.isTherapist,
    this.chatId,
    required this.userEmail,
  });

  @override
  State<WaitingDialog> createState() => _WaitingDialogState();
}

class _WaitingDialogState extends State<WaitingDialog> {
  String _countdown = '';
  bool _isPast = false;
  bool _isJoinable = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTimeStatus();
    if (!_isPast && !_isJoinable && widget.event.status == "Confirmed") {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTimeStatus();
        });
      }
    });
  }

  String _normalizeTime(String time) {
    if (time == "00:00") {
      return "12:00 AM";
    }
    return time
        .replaceAll(RegExp(r'am', caseSensitive: false), 'AM')
        .replaceAll(RegExp(r'pm', caseSensitive: false), 'PM');
  }

  void _updateTimeStatus() {
    final now = DateTime.now();
    DateTime? startDateTime;
    DateTime? endDateTime;

    try {
      final normalizedStartTime = _normalizeTime(widget.event.startTime);
      final normalizedEndTime = _normalizeTime(widget.event.endTime);

      // Parse times in local timezone (EAT, UTC+3)
      startDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
        '${widget.event.date} $normalizedStartTime',
      );

      endDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
        '${widget.event.date} $normalizedEndTime',
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }
    } catch (e) {
      print('Error parsing date/time: $e, date=${widget.event.date}, start=${widget.event.startTime}, end=${widget.event.endTime}');
      setState(() {
        _isPast = true;
        _countdown = 'Invalid date or time format';
      });
      _timer?.cancel();
      return;
    }

    if (widget.event.status == "Completed" || now.isAfter(endDateTime)) {
      _isPast = true;
      _isJoinable = false;
      _countdown = 'This session has ended';
      _timer?.cancel();
    } else if (widget.event.status == "Confirmed" &&
        now.isAfter(startDateTime.subtract(const Duration(minutes: 10))) &&
        now.isBefore(endDateTime)) {
      _isPast = false;
      _isJoinable = true;
      _countdown = 'The session is ready to join!';
      _timer?.cancel();
    } else if (widget.event.status == "Confirmed") {
      _isPast = false;
      _isJoinable = false;
      final difference = startDateTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;
      _countdown = 'Starts in ${hours}h ${minutes}m ${seconds}s';
    } else {
      _isPast = false;
      _isJoinable = false;
      _countdown = 'Waiting for confirmation';
    }
  }

  bool _isCreator() {
    return widget.event.createrId == widget.userId;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPending = widget.event.status == "Pending";
    final isCreator = _isCreator();

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateScheduledEventsBloc, UpdateScheduledEventsState>(
          listener: (context, state) {
            if (state is UpdateScheduledEventsLoaded) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meeting confirmed successfully')),
              );
              context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
            } else if (state is UpdateScheduledEventsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errorMessage}')),
              );
            }
          },
        ),
        BlocListener<DeleteScheduledEventsBloc, DeleteScheduledEventsState>(
          listener: (context, state) {
            if (state is DeleteScheduledEventsLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meeting cancelled successfully')),
              );
              context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
              Navigator.pop(context);
            } else if (state is DeleteScheduledEventsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.errorMessage}')),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PatientProfileBloc, GetPatientState>(
        bloc: widget.isTherapist ? context.read<PatientProfileBloc>() : null,
        builder: (context, patientState) {
          return BlocBuilder<TherapistProfileBloc, GetTherapistState>(
            bloc: !widget.isTherapist ? context.read<TherapistProfileBloc>() : null,
            builder: (context, therapistState) {
              UserEntity? receiver;
              if (widget.isTherapist && patientState is GetPatientLoaded) {
                receiver = UserEntity(
                  id: patientState.patient.id,
                  name: patientState.patient.name,
                  email: patientState.patient.email,
                  hasPassword: patientState.patient.hasPassword,
                  role: patientState.patient.role,
                );
              } else if (!widget.isTherapist && therapistState is GetTherapistLoaded) {
                receiver = UserEntity(
                  id: therapistState.therapist.id,
                  name: therapistState.therapist.name,
                  email: therapistState.therapist.email,
                  hasPassword: therapistState.therapist.hasPassword,
                  role: therapistState.therapist.role,
                );
              }

              if ((widget.isTherapist && patientState is GetPatientLoading) ||
                  (!widget.isTherapist && therapistState is GetTherapistLoading)) {
                return _buildWaitingShimmer(context);
              }

              if (receiver == null) {
                if (widget.isTherapist) {
                  context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: widget.event.patientId));
                } else {
                  context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: widget.event.therapistId));
                }
                return _buildWaitingShimmer(context);
              }

              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isPending && isCreator
                      ? _buildWaitingShimmer(context)
                      : _buildMeetingDetails(context, isPending, isCreator, receiver),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWaitingShimmer(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 24,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Waiting for ${widget.isTherapist ? "patient" : "therapist"} to confirm...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context: context,
              label: 'Close',
              color: Colors.grey[400]!,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingDetails(BuildContext context, bool isPending, bool isCreator, UserEntity receiver) {
    DateTime? startDateTime;
    DateTime? endDateTime;

    try {
      final normalizedStartTime = _normalizeTime(widget.event.startTime);
      final normalizedEndTime = _normalizeTime(widget.event.endTime);

      startDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
        '${widget.event.date} $normalizedStartTime',
      );

      endDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
        '${widget.event.date} $normalizedEndTime',
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }
    } catch (e) {
      print('Error parsing date/time: $e');
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red[900], size: 40),
              const SizedBox(height: 8),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Invalid date or time format',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                context: context,
                label: 'Close',
                color: Colors.grey[400]!,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    final isActive = widget.event.status == "Confirmed" &&
        DateTime.now().isAfter(startDateTime.subtract(const Duration(minutes: 10))) &&
        DateTime.now().isBefore(endDateTime);

    return 
    Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.event, color: Colors.blue[900], size: 28),
                const SizedBox(width: 8),
                Text(
                  'Meeting Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 12),
            // Details Section
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: widget.event.date,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Start Time',
              value: widget.event.startTime,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.access_time_filled,
              label: 'End Time',
              value: widget.event.endTime,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.check_circle,
              label: 'Status',
              value: widget.event.status,
              valueColor: widget.event.status == "Confirmed" ? Color(Colors.blue.value) : Color(Colors.yellow.value),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.monetization_on,
              label: 'Price',
              value: widget.event.price != null
                  ? NumberFormat.currency(locale: 'en_US', symbol: 'ETB ', decimalDigits: 2).format(widget.event.price)
                  : 'Not set',
            ),
            _buildDetailRow(
              icon: Icons.monetization_on,
              label: 'Creator',
              value: receiver.name
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            const SizedBox(height: 12),
            // Status Messages
            if (!_isPast && !_isJoinable && widget.event.status == "Confirmed")
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _countdown,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (_isJoinable)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'The session is ready to join!',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (_isPast)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'This session has already ended.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Action Buttons
            if (isPending && !isCreator) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    label: 'Confirm',
                    color: Colors.blue[700]!,
                    icon: Icons.check,
                    onPressed: () {
                      if (widget.isTherapist) {
                        context.read<UpdateScheduledEventsBloc>().add(
                              UpdateScheduledEventsEvent(
                                eventEntity: widget.event.copyWith(status: "Confirmed"),
                              ),
                            );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              therapistEmail: !widget.isTherapist ? receiver.email : widget.userEmail,
                              patientEmail: !widget.isTherapist ? widget.userEmail : receiver.email,
                              sessionHour: widget.event.endTime == "00:00"
                                  ? 1
                                  : double.parse(widget.event.endTime.split(':')[0]) -
                                      double.parse(widget.event.startTime.split(':')[0]),
                              event: widget.event,
                              chatId: widget.chatId,
                              receiver: receiver,
                              isCreate: false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  _buildActionButton(
                    context: context,
                    label: 'Cancel',
                    color: Colors.red[400]!,
                    icon: Icons.cancel,
                    onPressed: () {
                      context.read<DeleteScheduledEventsBloc>().add(
                            DeleteScheduledEventsEvent(calendarId: widget.event.id),
                          );
                    },
                  ),
                ],
              ),
            ],
            if (isActive)
              _buildActionButton(
                context: context,
                label: 'Join',
                color: Colors.green[400]!,
                icon: Icons.video_call,
                onPressed: () {
                  GoRouter.of(context).pushNamed(
                    'meeting',
                    queryParameters: {
                      'meetingId': widget.event.meetingId,
                      'token': widget.event.meetingToken,
                      'sessionId': widget.event.id,
                      'userId': widget.userId,
                      'isTherapist': widget.isTherapist.toString(),
                      'therapistId': widget.event.therapistId,
                    },
                  );
                },
              ),
            const SizedBox(height: 8),
            _buildActionButton(
              context: context,
              label: 'Close',
              color: Colors.grey[400]!,
              icon: Icons.close,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue[900], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(color: valueColor ?? Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20, color: Colors.white) : const SizedBox.shrink(),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }
}