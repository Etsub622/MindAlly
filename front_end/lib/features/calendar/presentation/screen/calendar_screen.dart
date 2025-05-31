import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/widget/waiting_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

enum EventStatus { Pending, Completed, Confirm }

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final _storage = const FlutterSecureStorage();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  Map<DateTime, List<EventEntity>> events = {};
  late final ValueNotifier<List<EventEntity>> _selectedEvents;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    fetchUserId();
    context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventEntity> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    }
  }
  
  Future<void> fetchUserId() async {
    final userCredential = await _storage.read(key: "user_profile") ?? '';
    if (userCredential.isNotEmpty) {
      final body = jsonDecode(userCredential);
      setState(() {
        userId = body["_id"].toString();
      });
    }
  }


  bool _isDayEnabled(DateTime day) {
    final today = DateTime.now();
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final normalizedToday = DateTime(today.year, today.month, today.day);
    return normalizedDay.isAfter(normalizedToday) || normalizedDay.isAtSameMomentAs(normalizedToday);
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.Pending:
        return Colors.amber[300]!;
      case EventStatus.Completed:
        return Colors.green[300]!;
      case EventStatus.Confirm:
        return Colors.blue[300]!;
    }
  }

  IconData _getStatusIcon(EventStatus status) {
    switch (status) {
      case EventStatus.Pending:
        return Icons.access_time;
      case EventStatus.Completed:
        return Icons.check_circle;
      case EventStatus.Confirm:
        return Icons.thumb_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[50]!, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    locale: "en_US",
                    rowHeight: 45,
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2030, 1, 1),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _onDaySelected,
                    enabledDayPredicate: _isDayEnabled,
                    eventLoader: _getEventsForDay,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue[700],
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(fontWeight: FontWeight.w500),
                      weekendTextStyle: TextStyle(color: Colors.red[400]),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: events.map((event) {
                              final eventEntity = event as EventEntity;
                              final status = eventEntity.status == null
                                  ? EventStatus.Pending
                                  : eventEntity.status == "Pending"
                                      ? EventStatus.Pending
                                      : eventEntity.status == "Completed"
                                          ? EventStatus.Completed
                                          : EventStatus.Confirm;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return null;
                      },
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      formatButtonTextStyle: const TextStyle(color: Colors.white),
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue[700]),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue[700]),
                    ),
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<GetScheduledEventsBloc, GetScheduledEventsState>(
                  builder: (context, state) {
                    if (state is GetScheduledEventsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetScheduledEventsLoaded) {
                      events.clear();
                      for (var eventEntity in state.events) {
                        try {
                          final dateParts = eventEntity.date.split('-').map(int.parse).toList();
                          final startTimeFormatted = eventEntity.startTime
                              .replaceAll(RegExp(r'am', caseSensitive: false), 'AM')
                              .replaceAll(RegExp(r'pm', caseSensitive: false), 'PM');
                          final startDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
                            '${eventEntity.date} $startTimeFormatted',
                          );
                          final normalizedDay = DateTime(
                            dateParts[0],
                            dateParts[1],
                            dateParts[2],
                          );
                          if (events[normalizedDay] == null) {
                            events[normalizedDay] = [eventEntity];
                          } else {
                            events[normalizedDay]!.add(eventEntity);
                          }
                          events[normalizedDay]!.sort((a, b) {
                            final aTime = DateFormat('hh:mm a').parse(
                              a.startTime.replaceAll(RegExp(r'am', caseSensitive: false), 'AM')
                                  .replaceAll(RegExp(r'pm', caseSensitive: false), 'PM'),
                            );
                            final bTime = DateFormat('hh:mm a').parse(
                              b.startTime.replaceAll(RegExp(r'am', caseSensitive: false), 'AM')
                                  .replaceAll(RegExp(r'pm', caseSensitive: false), 'PM'),
                            );
                            return aTime.hour * 60 + aTime.minute - (bTime.hour * 60 + bTime.minute);
                          });
                        } catch (e) {
                          print('Failed to parse event: ${eventEntity.date} ${eventEntity.startTime}, error: $e');
                          continue;
                        }
                      }
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);

                      return Container(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.4),
                        child: ValueListenableBuilder<List<EventEntity>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                final event = value[index];
                                final status = event.status == null
                                    ? EventStatus.Pending
                                    : event.status == "Pending"
                                        ? EventStatus.Pending
                                        : event.status == "Completed"
                                            ? EventStatus.Completed
                                            : EventStatus.Confirm;
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: _getStatusColor(status).withOpacity(0.7),
                                    child: GestureDetector(
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        leading: Icon(
                                          _getStatusIcon(status),
                                          color: _getStatusColor(status).withOpacity(1.0),
                                        ),
                                        title: const Text(
                                          "Meeting Session",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(event.startTime),
                                        trailing: Chip(
                                          label: Text(
                                            status.toString().split('.').last,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                          backgroundColor: _getStatusColor(status).withOpacity(0.9),
                                          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WaitingDialog(
                                              event: event,
                                              userId: userId,
                                              isTherapist: event.therapistId == userId,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is GetScheduledEventsError) {
                      return Center(child: Text('Error: ${state.errorMessage}'));
                    } else {
                      return const Center(child: Text('No events loaded'));
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}