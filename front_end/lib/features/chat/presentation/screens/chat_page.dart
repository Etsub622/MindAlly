import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/features/calendar/data/model/event_model.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
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

  @override
  void initState() {
    super.initState();
    currentChatId = widget.chatId;
    BlocProvider.of<ChatBloc>(context).add(LoadMessagesEvent(chatId: widget.chatId));
    fetchUserId();
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

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:  Text('Book Session with ${widget.receiver.name}'),
              scrollable: true,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.utc(2030, 1, 1),
                          );
                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: const Text('Pick Date'),
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
                              selectedTime = pickedTime;
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
                  onPressed: selectedDate != null && selectedTime != null
                      ? () {
                          final event = EventModel(
                            id: '', // Set by backend
                            userId: userId,
                            therapistId: widget.receiver.id,
                            date:
                                '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                            timeSlot:
                                '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                            status: 'Pending', // Set by backend
                            createdAt: DateTime.now(), // Set by backend
                            updatedAt: DateTime.now(), // Set by backend
                          );
                          context.read<AddScheduledEventsBloc>().add(
                                AddScheduledEventsEvent(eventEntity: event),
                              );
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Book'),
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
    return BlocListener<AddScheduledEventsBloc, AddScheduledEventsState>(
      listener: (context, state) {
        if (state is AddScheduledEventsLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session booked successfully')),
          );
        } else if (state is AddScheduledEventsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg"),
              ),
              const SizedBox(width: 10),
              Text(
                widget.receiver.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
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
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final content = messages[index];
                        final isSentMessage = content.senderId == userId;
                        if (isSentMessage) {
                          return _buildSentMessage(context, content.message);
                        } else {
                          return _buildReceiveMessage(context, content.message);
                        }
                      },
                    );
                  } else if (state is ChatErrorState) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const Center(child: Text("Failed to load messages"));
                  }
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showBookSessionDialog(context),
          child: const Icon(Icons.calendar_month_sharp),
        ),
      ),
    );
  }

  Widget _buildReceiveMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(right: 30, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 30, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}