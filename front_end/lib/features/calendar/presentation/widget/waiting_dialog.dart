import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/delete_event/delete_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WaitingDialog extends StatelessWidget {
  final EventEntity event;
  final String userId;
  final bool isTherapist;

  const WaitingDialog({
    super.key,
    required this.event,
    required this.userId,
    required this.isTherapist,
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
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isPending && isCreator
              ? _buildWaitingShimmer(context)
              : _buildMeetingDetails(context, isPending, isCreator),
        ),
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

  Widget _buildMeetingDetails(BuildContext context, bool isPending, bool isCreator) {
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
                  context.read<UpdateScheduledEventsBloc>().add(
                        UpdateScheduledEventsEvent(
                          eventEntity: event.copyWith(status: "Confirmed"),
                        ),
                      );
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
