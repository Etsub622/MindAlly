import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/screens/answer_creation.dart';
import 'package:front_end/features/Q&A/presentation/screens/answer_update.dart';
import 'package:front_end/features/Q&A/presentation/widget/answer_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentRoom extends StatefulWidget {
  final String questionId;
  final String currentUserRole;

  const CommentRoom(
      {super.key, required this.questionId, required this.currentUserRole});
  @override
  State<CommentRoom> createState() => _CommentRoomState();
}

class _CommentRoomState extends State<CommentRoom> {
  String? currentUserId;
  String? currentUserRole;
  @override
  void initState() {
    super.initState();
    context.read<AnswerBloc>().add(GetAnswerEvent(widget.questionId));
    _loadCurrentUserId();
  }

  void _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        print('userMap: $userMap');
        currentUserId = userMap["_id"] ?? '';
        currentUserRole = userMap["Role"];
      });
    } else {
      print('No user profile found in shared preferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Room'),
        actions: [
          if (widget.currentUserRole == 'therapist')
            IconButton(
              icon: Icon(Icons.add,
                  size: 30, color: Color.fromARGB(239, 130, 5, 220)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CreateAnswerBottomSheet(
                      questionId: widget.questionId,
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AnswerBloc, AnswerState>(
              listener: (context, state) {
                if (state is AnswerDeleted) {
                  context
                      .read<AnswerBloc>()
                      .add(GetAnswerEvent(widget.questionId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is AnswerAdded) {
                  context
                      .read<AnswerBloc>()
                      .add(GetAnswerEvent(widget.questionId));
                  final snack =
                      SnackBar(content: Text('Answer added successfully!'));
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                } else if (state is AnswerError) {
                  context
                      .read<AnswerBloc>()
                      .add(GetAnswerEvent(widget.questionId));
                  final snack = SnackBar(content: Text(state.message));
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                } else if (state is AnswerUpdated) {
                  context
                      .read<AnswerBloc>()
                      .add(GetAnswerEvent(widget.questionId));
                  final snack = snackBar('answer successfully Updated!');
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }
              },
              builder: (context, state) {
                if (state is AnswerLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AnswerError) {
                  return Center(child: Text(state.message));
                } else if (state is AnswerLoaded) {
                  final answers = state.answers;
                  if (answers.isEmpty) {
                    return Center(child: Text('No answers available.'));
                  }
                  return ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final ans = answers[index];
                      return AnswerCard(
                        answer: ans.answer,
                        therapistName: ans.therapistName,
                        therapistProfile: ans.therapistProfile,
                        onPressed: () {},
                        onDelete: () {
                          _showDeleteDialog(context, ans.id);
                        },
                        onUpdate: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return UpdateAnswerBottomSheet(
                                answerEntity: ans,
                                onUpdate: (updatedAnswer) {
                                  context
                                      .read<AnswerBloc>()
                                      .add(UpdateAnswerEvent(ans, ans.id));
                                },
                              );
                            },
                          );
                        },
                        currentUserId: currentUserId ?? '',
                        ownerId: ans.ownerId,
                        role: currentUserRole ?? '',
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete your answer?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AnswerBloc>().add(DeleteAnswerEvent(id));
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
