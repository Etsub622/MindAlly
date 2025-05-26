import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> selectedCategories = [];
  List<String> categoryOption = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.questionEntity.title);
    descriptionController =
        TextEditingController(text: widget.questionEntity.description);
    selectedCategories = widget.questionEntity.category;
    _getStudentId();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<String> _getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      return userMap["_id"] ?? '';
    }
    return '';
  }

  void _updateQuestion() async {
    final updatedQuestion = QuestionEntity(
      id: widget.questionEntity.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategories,
      studentName: widget.questionEntity.studentName,
      studentProfile: widget.questionEntity.studentProfile,
      creatorId: await _getStudentId(),
    );
    print('updatedQuestion:$updatedQuestion');
    context
        .read<QuestionBloc>()
        .add(UpdateQuestionEvent(updatedQuestion, widget.questionEntity.id));
    print('📤 Passed to onUpdate: $updatedQuestion');
    Navigator.pop(context);
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
            SizedBox(
              height: 10,
            ),
            MultiSelectDialogField<String>(
              items: categoryOption
                  .map((e) => MultiSelectItem<String>(e, e))
                  .toList(),
              initialValue: selectedCategories,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 215, 214, 214),
                    width: 1.0),
                borderRadius: BorderRadius.circular(15),
              ),
              buttonText: const Text('Book Category'),
              title: const Text('Book Category'),
              selectedColor: Colors.blue,
              buttonIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              onConfirm: (List<String> values) {
                setState(() {
                  selectedCategories = values;
                });
              },
              chipDisplay: MultiSelectChipDisplay<String>(
                items: selectedCategories
                    .map((category) =>
                        MultiSelectItem<String>(category, category))
                    .toList(),
                onTap: (value) {
                  setState(() {
                    selectedCategories.remove(value);
                  });
                },
                textStyle: const TextStyle(color: Colors.black),
                chipColor: Colors.white,
              ),
              searchable: true,
              searchHint: 'Search here...',
            ),
            const SizedBox(height: 20),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Update",
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedCategories.isNotEmpty) {
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
