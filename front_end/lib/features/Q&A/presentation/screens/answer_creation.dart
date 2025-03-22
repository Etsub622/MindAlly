import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';

class CreateAnswerBottomSheet extends StatefulWidget {
  final String questionId;

  const CreateAnswerBottomSheet({
    Key? key,
    required this.questionId,
  }) : super(key: key);

  @override
  _CreateAnswerBottomSheetState createState() =>
      _CreateAnswerBottomSheetState();
}

class _CreateAnswerBottomSheetState extends State<CreateAnswerBottomSheet> {
  TextEditingController answerController = TextEditingController();

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void _createAnswer() {
    final answerEntity = AnswerEntity(
      id: '',
      answer: answerController.text,
      therapistName: "therapistNameController",
      therapistProfile: "therapistProfileController",
      questionId: widget.questionId,
    );

    context.read<AnswerBloc>().add(AddAnswerEvent(answerEntity));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AnswerBloc, AnswerState>(
      builder: (context, state) {
        if (state is AnswerLoading) {
          return const CircularIndicator();
        } else {
          return _build(context);
        }
      },
      listener: (context, state) {
        if (state is AnswerAdded) {
          const snack = SnackBar(content: Text('Answer added successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snack);
          context.read<AnswerBloc>().add(GetAnswerEvent(widget.questionId)); 
          Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context).pop();
          });
        } else if (state is AnswerError) {
          final snack = errorsnackBar('Try again later');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
    ));
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Answer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomFormField(
              text: 'Answer',
              controller: answerController,
              maxline: 5,
            ),
            const SizedBox(height: 20),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Create",
              onPressed: () {
                if (answerController.text.isNotEmpty) {
                  _createAnswer();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
