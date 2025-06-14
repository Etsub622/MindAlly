import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/features/calendar/data/model/event_model.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/core/service/api_call.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/payment/presentation/screens/payment_screen.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String? chatId;
  final UserEntity receiver;

  const ChatPage({super.key, required this.chatId, required this.receiver});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? currentChatId;
  String userId = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    currentChatId = widget.chatId;
    BlocProvider.of<ChatBloc>(context)
        .add(LoadMessagesEvent(chatId: widget.chatId));
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    final userCredential = await _storage.read(key: "user_profile") ?? '';
    if (userCredential.isNotEmpty) {
      final body = jsonDecode(userCredential);
      setState(() {
        userId = body["_id"].toString();
        userEmail = body["Email"].toString();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendChatEvent(
        messageModel: MessageModel(
          chatId: currentChatId,
          message: message,
          senderId: userId,
          timestamp: DateTime.now(),
          isRead: false,
          receiverId: widget.receiver.id,
        ),
      ));
      _messageController.clear();
    }
  }

  void _showBookSessionDialog(BuildContext context) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    int? selectedDuration; // Duration in minutes

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Book Session with ${widget.receiver.name}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Select Date'
                                : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.utc(2030, 1, 1),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue[700]!,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setDialogState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: selectedDate != null ? Text('Pick') : Text('Update'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedTime == null
                                ? 'Select Time'
                                : 'Time: ${selectedTime!.format(context)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.blue[700]!,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null) {
                              setDialogState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: selectedTime!= null ? Text('Pick') : Text('Update'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDuration == null
                                ? 'Select Duration'
                                : 'Duration: ${selectedDuration! ~/ 60 > 0 ? "${selectedDuration! ~/ 60}h " : ""}${selectedDuration! % 60 > 0 ? "${selectedDuration! % 60}m" : ""}'
                                    .trim(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        DropdownButton<int>(
                          value: selectedDuration,
                          hint: const Text('Select Duration'),
                          items: const [
                            DropdownMenuItem(
                                value: 30, child: Text('30 minutes')),
                            DropdownMenuItem(value: 60, child: Text('1 hour')),
                            DropdownMenuItem(
                                value: 90, child: Text('1.5 hours')),
                            DropdownMenuItem(
                                value: 120, child: Text('2 hours')),
                          ],
                          onChanged: (value) {
                            setDialogState(() {
                              selectedDuration = value;
                            });
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: selectedDate != null &&
                                  selectedTime != null &&
                                  selectedDuration != null
                              ? () async {
                                EventModel? event;
                                  // call api to create meeting and then navigate to MeetingScreen with meetingId,token
                                  await createMeeting().then((meetingId) {
                                    if (!context.mounted) return;

                                    // Calculate endTime
                                    final startDateTime = DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute,
                                    );
                                    final endDateTime = startDateTime.add(
                                        Duration(minutes: selectedDuration!));
                                    final startTimeFormatted =
                                        DateFormat('hh:mm a')
                                            .format(startDateTime);
                                    final endTimeFormatted =
                                        DateFormat('hh:mm a')
                                            .format(endDateTime);

                                    event = EventModel(
                                      id: '',
                                      patientId: widget.receiver.role == "therapist" ? userId : widget.receiver.id,
                                      therapistId: widget.receiver.role == "therapist" ? widget.receiver.id : userId,
                                      createrId: userId, 
                                      date:
                                          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                                      startTime: startTimeFormatted,
                                      endTime: endTimeFormatted,
                                      status: 'Pending',
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(), 
                                      meetingId: meetingId,
                                      meetingToken: token,
                                      price: 0.0,
                                    );

                                   
                                  });
                              if(widget.receiver.role == "patient") {
                                      context.read<AddScheduledEventsBloc>().add(
                                          AddScheduledEventsEvent(eventEntity: event!),
                                        );
                                        Navigator.pop(context);
                                    }else{
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PaymentScreen(
                                                therapistEmail: widget.receiver.role == "therapist" ? widget.receiver.email : userEmail,
                                                patientEmail: widget.receiver.role == "therapist" ? userEmail : widget.receiver.email,
                                                sessionHour: selectedDuration! / 60,
                                                event: event!,
                                                chatId: currentChatId ?? '',
                                                receiver: widget.receiver,
                                                isCreate: true,
                                              ),
                                            ),
                                  );
                                    }
                                  
                                              
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Book',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddScheduledEventsBloc, AddScheduledEventsState>(
      listener: (context, state) {
        if (state is AddScheduledEventsLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Session booked successfully'),
              backgroundColor: Colors.green[700],
            ),
          );
        } else if (state is AddScheduledEventsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[50]!, Colors.white],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue[900],
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: const NetworkImage(
                            "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.receiver.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showBookSessionDialog(context),
                        // backgroundColor: Colors.blue[700],
                        // foregroundColor: Colors.white,
                        // elevation: 8,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: const Icon(
                          Icons.calendar_month_sharp,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatLoadedState) {
                        List<MessageEntity> messages = state.messages;
                        if (messages.isNotEmpty) {
                          currentChatId = messages.last.chatId;
                        } else {
                          currentChatId = null;
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final content = messages[index];
                            final isSentMessage = content.senderId == userId;
                            return AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: isSentMessage
                                  ? _buildSentMessage(context, content)
                                  : _buildReceiveMessage(context, content),
                            );
                          },
                        );
                      } else if (state is ChatErrorState) {
                        return Center(
                          child: Text(
                            state.errorMessage,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.red[700],
                                    ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Failed to load messages",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiveMessage(BuildContext context, MessageEntity message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 50, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[900],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp.toLocal()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, MessageEntity message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 50, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp.toLocal()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.camera_alt,
              color: Colors.blue[700],
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[900],
                  ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Icon(
              Icons.send,
              color: Colors.blue[700],
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
