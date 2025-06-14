import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class EventsAdminScreen extends StatefulWidget {
  const EventsAdminScreen({super.key});

  @override
  State<EventsAdminScreen> createState() => _EventsAdminScreenState();
}

class _EventsAdminScreenState extends State<EventsAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment processed successfully')),
          );
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Events'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<GetScheduledEventsBloc, GetScheduledEventsState>(
          builder: (context, state) {
            if (state is GetScheduledEventsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetScheduledEventsError) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is GetScheduledEventsLoaded) {
              final completedEvents = state.events.where((event) => event.status == 'Completed').toList();
              if (completedEvents.isEmpty) {
                return const Center(child: Text('No completed events found.'));
              }
              return ListView.builder(
                itemCount: completedEvents.length,
                itemBuilder: (context, index) {
                  final event = completedEvents[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event ID: ${event.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Time: ${event.startTime} - ${event.endTime}'),
                          const SizedBox(height: 16),
                          _buildCheckInOutChart(event),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showWarningDialog(context, 'approve', event);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Approve'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _showWarningDialog(context, 'refund', event);
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text('Refund'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCheckInOutChart(EventEntity event) {
    final patientCheckInTimes = event.patientCheckInTimes
        .whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? time['time'] : null)
        .whereType<DateTime>()
        .toList();
    final patientCheckOutTimes = event.patientCheckOutTimes
        .whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? time['time'] : null)
        .whereType<DateTime>()
        .toList();
    final therapistCheckInTimes = event.therapistCheckInTimes
        ?.whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? time['time'] : null)
        .whereType<DateTime>()
        .toList() ?? [];
    final therapistCheckOutTimes = event.therapistCheckOutTimes
        ?.whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? time['time'] : null)
        .whereType<DateTime>()
        .toList() ?? [];

    if ((patientCheckInTimes.isEmpty && patientCheckOutTimes.isEmpty) &&
        (therapistCheckInTimes.isEmpty && therapistCheckOutTimes.isEmpty)) {
      return const Center(child: Text('No check-in/out data available.'));
    }

    // Find the overall time span
    final allTimes = [
      ...patientCheckInTimes,
      ...patientCheckOutTimes,
      ...therapistCheckInTimes,
      ...therapistCheckOutTimes,
    ];
    if (allTimes.isEmpty) {
      return const Center(child: Text('No valid time data available.'));
    }
    final minTime = allTimes.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxTime = allTimes.reduce((a, b) => a.isAfter(b) ? a : b);
    final totalSpanMinutes = maxTime.difference(minTime).inMinutes.toDouble();

    // Calculate total durations
    int patientTotalDuration = 0;
    int therapistTotalDuration = 0;
    final patientSessions = patientCheckInTimes.length < patientCheckOutTimes.length
        ? patientCheckInTimes.length
        : patientCheckOutTimes.length;
    final therapistSessions = therapistCheckInTimes.length < therapistCheckOutTimes.length
        ? therapistCheckInTimes.length
        : therapistCheckOutTimes.length;

    final barGroups = <BarChartGroupData>[];

    // Patient bars (y=2 for positioning)
    for (int i = 0; i < patientSessions; i++) {
      final checkInOffset = minTime.difference(patientCheckInTimes[i]).inMinutes.abs().toDouble();
      final duration = patientCheckOutTimes[i].difference(patientCheckInTimes[i]).inMinutes.toDouble();
      if (duration > 0) {
        patientTotalDuration += duration.toInt();
        barGroups.add(
          BarChartGroupData(
            x: checkInOffset.toInt(),
            barRods: [
              BarChartRodData(
                toY: 2,
                fromY: 1.5,
                width: duration,
                color: Colors.blue,
                borderRadius: BorderRadius.zero,
              ),
            ],
          ),
        );
      }
    }

    // Therapist bars (y=1 for positioning)
    for (int i = 0; i < therapistSessions; i++) {
      final checkInOffset = minTime.difference(therapistCheckInTimes[i]).inMinutes.abs().toDouble();
      final duration = therapistCheckOutTimes[i].difference(therapistCheckInTimes[i]).inMinutes.toDouble();
      if (duration > 0) {
        therapistTotalDuration += duration.toInt();
        barGroups.add(
          BarChartGroupData(
            x: checkInOffset.toInt(),
            barRods: [
              BarChartRodData(
                toY: 1,
                fromY: 0.5,
                width: duration,
                color: Colors.green,
                borderRadius: BorderRadius.zero,
              ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      if (value == 1) return const Text('Therapist', style: TextStyle(fontSize: 12));
                      if (value == 2) return const Text('Patient', style: TextStyle(fontSize: 12));
                      return const Text('');
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final minutes = value.toInt();
                      return Text(
                        '$minutes min',
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                    interval: totalSpanMinutes / 5,
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final type = rod.toY == 2 ? 'Patient' : 'Therapist';
                    final startMin = group.x;
                    final duration = rod.width;
                    return BarTooltipItem(
                      '$type: $startMin + $duration min',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              maxY: 2.7,
              minY: 0,
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(y: 1, color: Colors.grey.withOpacity(0.2)),
                  HorizontalLine(y: 2, color: Colors.grey.withOpacity(0.2)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Patient Total: $patientTotalDuration min',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          'Therapist Total: $therapistTotalDuration min',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showWarningDialog(BuildContext context, String action, EventEntity event) {
    context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: event.patientId));
    context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: event.therapistId));

    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<PatientProfileBloc, GetPatientState>(
        builder: (context, patientState) => BlocBuilder<TherapistProfileBloc, GetTherapistState>(
          builder: (context, therapistState) {
            if (patientState is GetPatientLoading || therapistState is GetTherapistLoading) {
              return const AlertDialog(
                title: Text('Loading'),
                content: Center(child: CircularProgressIndicator()),
              );
            }
            if (patientState is GetPatientError || therapistState is GetTherapistError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(
                  'Failed to load data: ${patientState is GetPatientError ? "of patient" : ''}${therapistState is GetTherapistError ? "of therapist" : ''}',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              );
            }
            String? patientEmail;
            String? therapistEmail;
            if (patientState is GetPatientLoaded) {
              patientEmail = patientState.patient.email;
            }
            if (therapistState is GetTherapistLoaded) {
              therapistEmail = therapistState.therapist.email;
            }
            if ((action == 'approve' && therapistEmail == null) || (action == 'refund' && patientEmail == null)) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('${action == 'approve' ? 'Therapist' : 'Patient'} email not available'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              );
            }
            return AlertDialog(
              title: const Text('Confirm Action'),
              content: Text('Are you sure you want to ${action == 'approve' ? 'pay the therapist' : 'refund the patient'}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final bloc = context.read<PaymentBloc>();
                    bloc.add(
                      WithdrawPaymentEvent(
                        email: action == 'approve' ? therapistEmail! : patientEmail!,
                        amount: event.price,
                      ),
                    );
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment ${action}d for event ${event.id}')),
                    );
                  },
                  child: Text(action == 'approve' ? 'Approve' : 'Refund'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}