import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';

class CreateQuestionBottomSheet extends StatefulWidget {
  const CreateQuestionBottomSheet({Key? key}) : super(key: key);

  @override
  _CreateQuestionBottomSheetState createState() =>
      _CreateQuestionBottomSheetState();
}

class _CreateQuestionBottomSheetState extends State<CreateQuestionBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> selectedCategories = [];
  String? studentId;
  String? studentName;
  String? studentProfile;

  final List<String> categoryOption = const [
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
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      studentId = userMap['_id'] ?? '';
      studentName = userMap['FullName'] ?? '';
    }
    if (studentId != null && studentId!.isNotEmpty) {
      context
          .read<PatientProfileBloc>()
          .add(GetPatientLoadEvent(patientId: studentId!));
    }
  }

  Future<String> _getStudentId() async {
    return studentId ?? '';
  }

  Future<String> _getStudentName() async {
    return studentName ?? '';
  }

  Future<String> _getStudentProfile() async {
    return studentProfile ?? '';
  }

  void _createQuestion() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty && studentProfile != null) {
      final name = await _getStudentName();
      final creatorId = await _getStudentId();
      final profilePic = await _getStudentProfile();
      final questionEntity = QuestionEntity(
        id: '',
        title: title,
        description: description,
        studentName: name,
        creatorId: creatorId,
        studentProfile: profilePic,
        category: selectedCategories,
      );

      print('creatorId: ${questionEntity.creatorId}');
      print('userName: ${questionEntity.studentName}');
      print('studentProfile: ${questionEntity.studentProfile}');

      context.read<QuestionBloc>().add(AddQuestionEvent(questionEntity));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill in all fields and wait for profile data to load.')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientProfileBloc, GetPatientState>(
      listener: (context, state) {
        if (state is GetPatientLoaded) {
          setState(() {
            studentProfile = state.patient.profilePicture ?? '';
            studentName = state.patient.name;
          });
        } else if (state is GetPatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorsnackBar('Failed to load student data: ${state.message}'),
          );
        }
      },
      builder: (context, state) {
        if (state is GetPatientLoading) {
          return const CircularIndicator();
        }
        return Scaffold(
          body: BlocConsumer<QuestionBloc, QuestionState>(
            builder: (context, questionState) {
              if (questionState is QuestionLoading) {
                return const CircularIndicator();
              }
              return _build(context);
            },
            listener: (context, questionState) {
              if (questionState is QuestionAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question added successfully')),
                );
                Navigator.of(context).pop();
                context.read<QuestionBloc>().add(GetQuestionEvent());
              } else if (questionState is QuestionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorsnackBar('Try again later'),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              text: 'Title',
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              text: 'Description',
              controller: _descriptionController,
              maxline: 5,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: MultiSelectDialogField<String>(
                items: categoryOption
                    .map((e) => MultiSelectItem<String>(e, e))
                    .toList(),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 215, 214, 214),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                buttonText: const Text('Question Category'),
                title: const Text('Question Category'),
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
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Create Question',
              onPressed: _createQuestion,
              rad: 10,
              hgt: 50,
            ),
          ],
        ),
      ),
    );
  }
}
