import 'package:flutter/material.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
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
  late TextEditingController therapistNameController;
  late TextEditingController therapistProfileController;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController(text: widget.answerEntity.answer);
    therapistNameController =
        TextEditingController(text: widget.answerEntity.therapistName);
    therapistProfileController =
        TextEditingController(text: widget.answerEntity.therapistProfile);
  }

  @override
  void dispose() {
    answerController.dispose();
    therapistNameController.dispose();
    therapistProfileController.dispose();
    super.dispose();
  }

  void _updateAnswer() {
    final Map<String, Object> updatedAnswer = {
      'id': widget.answerEntity.id,
      'answer': answerController.text,
      'therapistName': therapistNameController.text,
      'therapistProfile': therapistProfileController.text,
      'questionId': widget.answerEntity.questionId,
    };
    widget.onUpdate(updatedAnswer);
    Navigator.of(context).pop(); // Close the bottom sheet after updating
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Answer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomFormField(
                text: 'Answer', controller: answerController),
            const SizedBox(height: 10),
            CustomFormField(
                text: 'Therapist Name', controller: therapistNameController),
            const SizedBox(height: 10),
            CustomFormField(
                text: 'Therapist Profile URL',
                controller: therapistProfileController),
            const SizedBox(height: 20),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Update",
              onPressed: () {
                if (answerController.text.isNotEmpty &&
                    therapistNameController.text.isNotEmpty) {
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
