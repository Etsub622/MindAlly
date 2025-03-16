import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';

class CreateAnswerBottomSheet extends StatefulWidget {
  final String questionId;
  final Function(Map<String, Object>) onCreate;

  const CreateAnswerBottomSheet({
    Key? key,
    required this.questionId,
    required this.onCreate,
  }) : super(key: key);

  @override
  _CreateAnswerBottomSheetState createState() =>
      _CreateAnswerBottomSheetState();
}

class _CreateAnswerBottomSheetState extends State<CreateAnswerBottomSheet> {
  late TextEditingController answerController;
  late TextEditingController therapistNameController;
  late TextEditingController therapistProfileController;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController();
    therapistNameController = TextEditingController();
    therapistProfileController = TextEditingController();
  }

  @override
  void dispose() {
    answerController.dispose();
    therapistNameController.dispose();
    therapistProfileController.dispose();
    super.dispose();
  }

  void _createAnswer() {
    final Map<String, Object> newAnswer = {
      'id': '', // ID can be generated on the server
      'answer': answerController.text,
      'therapistName': therapistNameController.text,
      'therapistProfile': therapistProfileController.text,
      'questionId': widget.questionId,
    };
    widget.onCreate(newAnswer);
    Navigator.of(context).pop(); // Close the bottom sheet after creating
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Answer',
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
              text: "Create",
              onPressed: () {
                if (answerController.text.isNotEmpty &&
                    therapistNameController.text.isNotEmpty) {
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
