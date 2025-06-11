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

class WaitingDialog extends StatelessWidget {
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

  bool _isCreator() {
    return event.createrId == userId;
  }

  @override
  Widget build(BuildContext context) {
    final isPending = event.status == "Pending";
    final isCreator = _isCreator();

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateScheduledEventsBloc, UpdateScheduledEventsState>(
          listener: (context, state) {
            if (state is UpdateScheduledEventsLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meeting confirmed successfully')),
              );
              context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
              Navigator.pop(context);
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
        bloc: isTherapist ? context.read<PatientProfileBloc>() : null,
        builder: (context, patientState) {
          return BlocBuilder<TherapistProfileBloc, GetTherapistState>(
            bloc: !isTherapist ? context.read<TherapistProfileBloc>() : null,
            builder: (context, therapistState) {
              UserEntity? receiver;
              if (isTherapist && patientState is GetPatientLoaded) {
                receiver = UserEntity(
                  id: patientState.patient.id,
                  name: patientState.patient.name,
                  email: patientState.patient.email,
                  hasPassword: patientState.patient.hasPassword,
                  role: patientState.patient.role,
                );
              } else if (!isTherapist && therapistState is GetTherapistLoaded) {
                receiver = UserEntity(
                  id: therapistState.therapist.id,
                  name: therapistState.therapist.name,
                  email: therapistState.therapist.email,
                  hasPassword: therapistState.therapist.hasPassword,
                  role: therapistState.therapist.role,
                );
              }

              if ((isTherapist && patientState is GetPatientLoading) ||
                  (!isTherapist && therapistState is GetTherapistLoading)) {
                return _buildWaitingShimmer(context);
              }

              if (receiver == null) {
                // Trigger data fetch if not yet loaded
                if (isTherapist) {
                  context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: event.patientId));
                } else {
                  context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: event.therapistId));
                }
                return _buildWaitingShimmer(context);
              }

              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 24,
            width: double.infinity,
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
          'Waiting for ${isTherapist ? "patient" : "therapist"} to confirm...',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildMeetingDetails(BuildContext context, bool isPending, bool isCreator, UserEntity receiver) {
    final dateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
      '${event.date} ${event.startTime.replaceAll(RegExp(r'am|pm', caseSensitive: false), event.startTime.contains('AM') ? 'AM' : 'PM')}',
    );
    final isActive = event.status == "Confirmed" &&
        DateTime.now().isAfter(dateTime.subtract(const Duration(minutes: 10))) &&
        DateTime.now().isBefore(DateTime.parse('${event.date} ${event.endTime}'));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting Session',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        Text('Date: ${event.date}'),
        Text('Start Time: ${event.startTime}'),
        Text('End Time: ${event.endTime}'),
        Text('Status: ${event.status}'),
        Text('Creator ID: ${event.createrId}'),
        if (event.therapistId == userId)
          Text('Patient ID: ${event.patientId}')
        else
          Text('Therapist ID: ${event.therapistId}'),
        const SizedBox(height: 16),
        if (isPending && !isCreator) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  isTherapist
                      ? context.read<UpdateScheduledEventsBloc>().add(
                          UpdateScheduledEventsEvent(
                            eventEntity: event.copyWith(status: "Confirmed"),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              therapistEmail: !isTherapist ? receiver.email : userEmail,
                              patientEmail: !isTherapist ? userEmail : receiver.email,
                              sessionHour: event.endTime == "00:00" ? 1 : double.parse(event.endTime.split(':')[0]) - double.parse(event.startTime.split(':')[0]),
                              event: event,
                              chatId: chatId,
                              receiver: receiver,
                              isCreate:false,
                            ),
                          ),
                        );
                  // Removed duplicate UpdateScheduledEventsEvent call
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirm'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<DeleteScheduledEventsBloc>().add(
                        DeleteScheduledEventsEvent(calendarId: event.id),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
        if (isActive)
          ElevatedButton(
            onPressed: () {
              context.goNamed('meeting', extra: {
                'meetingId': event.meetingId,
                'token': event.meetingToken,
                'sessionId': event.id,
                'userId': userId,
                'isTherapist': isTherapist,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Join Meeting'),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
