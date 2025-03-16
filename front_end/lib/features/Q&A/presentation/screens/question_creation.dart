import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';

class CreateQuestionBottomSheet extends StatefulWidget {
  const CreateQuestionBottomSheet({Key? key}) : super(key: key);

  @override
  _CreateQuestionBottomSheetState createState() =>
      _CreateQuestionBottomSheetState();
}

class _CreateQuestionBottomSheetState extends State<CreateQuestionBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentProfileController =
      TextEditingController();
  final List<String> _categories = []; // To hold selected categories

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _studentNameController.dispose();
    _studentProfileController.dispose();
    super.dispose();
  }

  void _createQuestion() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final studentName = _studentNameController.text.trim();
    final studentProfile = _studentProfileController.text.trim();

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        studentName.isNotEmpty &&
        studentProfile.isNotEmpty) {
      final questionEntity = QuestionEntity(
        id: '', 
        title: title,
        description: description,
        studentName: studentName,
        studentProfile: studentProfile,
        category: _categories,
      );

      context.read<QuestionBloc>().add(AddQuestionEvent(questionEntity));
      Navigator.of(context).pop(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _studentNameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _studentProfileController,
            decoration: InputDecoration(
              labelText: 'Profile Image URL',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _createQuestion,
            child: Text('Create Question'),
          ),
        ],
      ),
    );
  }
}
