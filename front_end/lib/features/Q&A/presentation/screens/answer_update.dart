import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';

class UpdateAnswerBottomSheet extends StatefulWidget {
  final AnswerEntity answerEntity;
  final Function(Map<String, Object>) onUpdate;

  const UpdateAnswerBottomSheet({
    Key? key,
    required this.answerEntity,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateAnswerBottomSheetState createState() =>
      _UpdateAnswerBottomSheetState();
}

class _UpdateAnswerBottomSheetState extends State<UpdateAnswerBottomSheet> {
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController(text: widget.answerEntity.answer);
  }

  @override
  void dispose() {
    answerController.dispose();

    super.dispose();
  }

  void _updateAnswer() async {
    final updatedAnswer = AnswerEntity(
      id: widget.answerEntity.id,
      questionId: widget.answerEntity.questionId,
      answer: answerController.text.trim(),
      therapistName: widget.answerEntity.therapistName,
      therapistProfile: widget.answerEntity.therapistProfile,
      ownerId: widget.answerEntity.ownerId,
    );

    context
        .read<AnswerBloc>()
        .add(UpdateAnswerEvent(updatedAnswer, widget.answerEntity.id));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 40, 
        bottom: MediaQuery.of(context).viewInsets.bottom +
            20, 
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Answer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomFormField(text: 'Answer', controller: answerController),
            const SizedBox(height: 20),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Update",
              onPressed: () {
                if (answerController.text.isNotEmpty) {
                  _updateAnswer();
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
