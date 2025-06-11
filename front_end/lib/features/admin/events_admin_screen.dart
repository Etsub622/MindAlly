import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Events'),
        actions: [
          IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
          ),
        ]
        
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
                        Text('Date: ${event.date}'),
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
    );
  }

  Widget _buildCheckInOutChart(EventEntity event) {
    final checkInTimes = event.patientCheckInTimes
        .whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? DateTime.tryParse(time['time'] as String) : null)
        .whereType<DateTime>()
        .toList();
    final checkOutTimes = event.patientCheckOutTimes
        .whereType<Map<String, dynamic>>()
        .map((time) => time['time'] != null ? DateTime.tryParse(time['time'] as String) : null)
        .whereType<DateTime>()
        .toList();

    if (checkInTimes.isEmpty && checkOutTimes.isEmpty) {
      return const Center(child: Text('No check-in/out data available.'));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            if (checkInTimes.isNotEmpty)
              LineChartBarData(
                spots: checkInTimes.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.millisecondsSinceEpoch.toDouble());
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                dotData: const FlDotData(show: true),
              ),
            if (checkOutTimes.isNotEmpty)
              LineChartBarData(
                spots: checkOutTimes.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.millisecondsSinceEpoch.toDouble());
                }).toList(),
                isCurved: true,
                color: Colors.red,
                barWidth: 2,
                dotData: const FlDotData(show: true),
              ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context, String action, EventEntity event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text('Are you sure you want to ${action == 'approve' ? 'approve' : 'decline'} the payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment ${action}d for event ${event.id}')),
              );
            },
            child: Text(action == 'approve' ? 'Approve' : 'Decline'),
          ),
        ],
      ),
    );
  }
}