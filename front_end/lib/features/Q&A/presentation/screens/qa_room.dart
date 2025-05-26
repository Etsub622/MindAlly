import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/features/Q&A/presentation/screens/answer_creation.dart';
import 'package:front_end/features/Q&A/presentation/screens/comment_room.dart';
import 'package:front_end/features/Q&A/presentation/screens/question_creation.dart';
import 'package:front_end/features/Q&A/presentation/screens/update_question.dart';
import 'package:front_end/features/Q&A/presentation/widget/question_card.dart';
import 'package:front_end/features/Q&A/presentation/widget/search_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QARoom extends StatefulWidget {
  const QARoom({super.key});

  @override
  State<QARoom> createState() => _QARoomState();
}

class _QARoomState extends State<QARoom> {
  String? currentUserId;
  String? currentUserRole;

  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(GetQuestionEvent());
    _loadCurrentUserId();
  }

  final List<String> questionCategory = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
 void _loadCurrentUserId() async {
    final userJson = await _secureStorage.read(key: 'user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        print('userMap: $userMap');
        currentUserId = userMap["_id"] ?? '';
        currentUserRole = userMap["role"];
      });
    } else {
      print('No user profile found in secure storage');
    }
  }


  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 225, 225),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Filter by category',
                          style: TextStyle(
                            color: Color.fromARGB(239, 130, 5, 220),
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.filter_list,
                          color: Color.fromARGB(239, 130, 5, 220)),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                          context
                              .read<QuestionBloc>()
                              .add(SearchQuestionEvent(newValue));
                        }
                      },
                      items: questionCategory.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Color.fromARGB(239, 130, 5, 220),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: Color.fromARGB(239, 130, 5, 220), size: 25),
            onPressed: () {
              context.read<QuestionBloc>().add(GetQuestionEvent());
            },
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CreateQuestionBottomSheet();
                },
              );
            },
            icon: Icon(
              Icons.add,
              color: Color.fromARGB(239, 130, 5, 220),
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<QuestionBloc, QuestionState>(
                listener: (context, state) {
                  if (state is QuestionDeleted) {
                    context.read<QuestionBloc>().add(GetQuestionEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is QuestionError) {
                    context.read<QuestionBloc>().add(GetQuestionEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is QuestionUpdated) {
                    context.read<QuestionBloc>().add(GetQuestionEvent());
                    final snack = snackBar('question successfully Updated!');
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                },
                builder: (context, state) {
                  if (state is QuestionLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SearchFailed) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  } else if (state is QuestionLoaded) {
                    final questions = state.questions;
                    if (questions.isEmpty) {
                      return Center(child: Text('No questions available.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return QuestionCard(
                          name: question.studentName,
                          title: question.title,
                          content: question.description,
                          category: question.category,
                          profileImage: question.studentProfile,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommentRoom(questionId: question.id),
                              ),
                            );
                          },
                          onUpdate: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return UpdateQuestionBottomSheet(
                                  questionEntity: question,
                                  onUpdate: (updatedQuestion) {
                                    context.read<QuestionBloc>().add(
                                        UpdateQuestionEvent(
                                            question, question.id));
                                  },
                                );
                              },
                            );
                          },
                          onDelete: () {
                            _showDeleteDialog(context, question.id);
                          },
                          currentUserId: currentUserId ?? '',
                          ownerId: question.creatorId,
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
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete your question?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<QuestionBloc>().add(DeleteQuestionEvent(id));
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
