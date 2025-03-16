import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';

class UpdateQuestionBottomSheet extends StatefulWidget {
  final QuestionEntity questionEntity;
  final Function(Map<String, Object>) onUpdate;

  const UpdateQuestionBottomSheet({
    Key? key,
    required this.questionEntity,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _UpdateQuestionBottomSheetState createState() =>
      _UpdateQuestionBottomSheetState();
}

class _UpdateQuestionBottomSheetState extends State<UpdateQuestionBottomSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController studentNameController;
  late TextEditingController studentProfileController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.questionEntity.title);
    descriptionController =
        TextEditingController(text: widget.questionEntity.description);
    studentNameController =
        TextEditingController(text: widget.questionEntity.studentName);
    studentProfileController =
        TextEditingController(text: widget.questionEntity.studentProfile);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    studentNameController.dispose();
    studentProfileController.dispose();
    super.dispose();
  }

  void _updateQuestion() {
    final Map<String, Object> updatedQuestion = {
      'id': widget.questionEntity.id,
      'title': titleController.text,
      'description': descriptionController.text,
      'studentName': studentNameController.text,
      'studentProfile': studentProfileController.text,
      // Add category if needed
      'category':
          widget.questionEntity.category, // Assuming categories remain the same
    };
    widget.onUpdate(updatedQuestion);
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
            Text('Update Question',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomFormField(text: 'Title', controller: titleController),
            const SizedBox(height: 10),
            CustomFormField(
                text: 'Description',
                controller: descriptionController,
                ),
            const SizedBox(height: 10),
            CustomFormField(
                text: 'Student Name', controller: studentNameController),
            const SizedBox(height: 10),
            CustomFormField(
                text: 'Profile Image URL',
                controller: studentProfileController),
            const SizedBox(height: 20),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Update",
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  _updateQuestion();
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
