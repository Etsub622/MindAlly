import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final TimeOfDay time;

  Event(this.title, this.time);

  @override
  String toString() => '$title at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _selectedTime;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // Trigger loading of events from backend
    context.read<GetScheduledEventsBloc>().add(GetScheduledEventsEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
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

  bool _isDayEnabled(DateTime day) {
    final today = DateTime.now();
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final normalizedToday = DateTime(today.year, today.month, today.day);
    return normalizedDay.isAfter(normalizedToday) || normalizedDay.isAtSameMomentAs(normalizedToday);
  }

  void _showAddEventDialog(BuildContext context) {
    _selectedTime = null;
    _titleController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Event'),
              scrollable: true,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Event Title'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedTime == null
                              ? 'Select Time'
                              : 'Time: ${_selectedTime!.format(context)}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              _selectedTime = pickedTime;
                            });
                          }
                        },
                        child: const Text('Pick Time'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _titleController.text.isNotEmpty && _selectedTime != null
                      ? () {
                          final normalizedDay = DateTime(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                          );
                          setState(() {
                            final newEvent = Event(_titleController.text, _selectedTime!);
                            if (events[normalizedDay] == null) {
                              events[normalizedDay] = [newEvent];
                            } else {
                              events[normalizedDay]!.add(newEvent);
                            }
                            events[normalizedDay]!.sort((a, b) => a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute));
                            _selectedEvents.value = _getEventsForDay(_selectedDay!);
                          });
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Calendar - Events'),
      ),
      body: BlocBuilder<GetScheduledEventsBloc, GetScheduledEventsState>(
        builder: (context, state) {
          if (state is GetScheduledEventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetScheduledEventsLoaded) {
            // Map EventEntity to Event and populate events map
            events.clear();
            for (var eventEntity in state.events) {
              final normalizedDay = DateTime(
                eventEntity.startTime.year,
                eventEntity.startTime.month,
                eventEntity.startTime.day,
              );
              final event = Event(
                "Metting Session",
                TimeOfDay(
                  hour: eventEntity.startTime.hour,
                  minute: eventEntity.startTime.minute,
                ),
              );
              if (events[normalizedDay] == null) {
                events[normalizedDay] = [event];
              } else {
                events[normalizedDay]!.add(event);
              }
              // Sort events by time
              events[normalizedDay]!.sort((a, b) => a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute));
            }
            // Update selected events for the current day
            _selectedEvents.value = _getEventsForDay(_selectedDay!);

            return Column(
              children: [
                TableCalendar(
                  locale: "en_US",
                  rowHeight: 35,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: _onDaySelected,
                  enabledDayPredicate: _isDayEnabled,
                  eventLoader: _getEventsForDay,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
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
                const SizedBox(height: 8),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(value[index].title),
                              subtitle: Text(value[index].time.format(context)),
                              onTap: () => print('${value[index]}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is GetScheduledEventsError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const Center(child: Text('No events loaded'));
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showAddEventDialog(context),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}