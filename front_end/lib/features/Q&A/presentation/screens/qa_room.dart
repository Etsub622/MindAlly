import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/features/Q&A/presentation/screens/answer_creation.dart';
import 'package:front_end/features/Q&A/presentation/screens/comment_room.dart';
import 'package:front_end/features/Q&A/presentation/screens/question_creation.dart';
import 'package:front_end/features/Q&A/presentation/screens/update_question.dart';
import 'package:front_end/features/Q&A/presentation/widget/question_card.dart';
import 'package:front_end/features/Q&A/presentation/widget/search_box.dart';

class QARoom extends StatefulWidget {
  const QARoom({super.key});

  @override
  State<QARoom> createState() => _QARoomState();
}

class _QARoomState extends State<QARoom> {
  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(GetQuestionEvent());
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchInputField(
            controller: _searchController,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CreateQuestionBottomSheet();
                },
              );
            },
            child: Text('Add Question'),
          ),
          Expanded(
            child: BlocBuilder<QuestionBloc, QuestionState>(
              builder: (context, state) {
                if (state is QuestionLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is QuestionError) {
                  return Center(child: Text(state.message));
                } else if (state is QuestionLoaded) {
                  final questions = state.questions;
                  if (questions.isEmpty) {
                    return Center(child: Text('No question available.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
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
