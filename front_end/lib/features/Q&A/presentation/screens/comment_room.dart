import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/screens/answer_creation.dart';
import 'package:front_end/features/Q&A/presentation/widget/answer_card.dart';

class CommentRoom extends StatefulWidget {
  final String questionId;
  const CommentRoom({super.key, required this.questionId});

  @override
  State<CommentRoom> createState() => _CommentRoomState();
}

class _CommentRoomState extends State<CommentRoom> {
  @override
  void initState() {
    super.initState();
    context.read<AnswerBloc>().add(GetAnswerEvent(widget.questionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AnswerBloc, AnswerState>(
              listener: (context, state) {
                if (state is AnswerAdded) {
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
                        onDelete: () {},
                        onUpdate: () {},
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
          ElevatedButton(
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
            child: Text('Add Answer'),
          ),
        ],
      ),
    );
  }
}
