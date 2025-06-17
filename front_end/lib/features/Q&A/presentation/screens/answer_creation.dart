import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';

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
  String? therapistId;
  String? therapistName;
  String? therapistProfile;

  @override
  void initState() {
    super.initState();
    _loadTherapistData();
  }

  Future<void> _loadTherapistData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      therapistId = userMap['_id'] ?? '';
      therapistName = userMap['FullName'] ?? '';
    }
    if (therapistId != null && therapistId!.isNotEmpty) {
      context
          .read<TherapistProfileBloc>()
          .add(GetTherapistLoadEvent(therapistId: therapistId!));
    }
  }

  Future<String> _getTherapistId() async {
    return therapistId ?? '';
  }

  Future<String> _getTherapistName() async {
    return therapistName ?? '';
  }

  Future<String> _getTherapistProfile() async {
    return therapistProfile ?? '';
  }

  void _createAnswer() async {
    if (therapistProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorsnackBar('Please wait for profile data to load'),
      );
      return;
    }
    final creatorId = await _getTherapistId();
    final name = await _getTherapistName();
    final profilePic = await _getTherapistProfile();
    final answerEntity = AnswerEntity(
      id: '',
      answer: answerController.text,
      therapistName: name,
      therapistProfile: profilePic,
      questionId: widget.questionId,
      ownerId: creatorId,
    );

    context.read<AnswerBloc>().add(AddAnswerEvent(answerEntity));
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistProfileBloc, GetTherapistState>(
      listener: (context, state) {
        if (state is GetTherapistLoaded) {
          setState(() {
            therapistProfile = state.therapist.profilePicture ?? '';
            therapistName = state.therapist.name;
          });
        } else if (state is GetTherapistError) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorsnackBar('Failed to load therapist data: ${state.message}'),
          );
        }
      },
      builder: (context, state) {
        if (state is GetTherapistLoading) {
          return const CircularIndicator();
        }
        return BlocConsumer<AnswerBloc, AnswerState>(
          builder: (context, answerState) {
            if (answerState is AnswerLoading) {
              return const CircularIndicator();
            }
            return _build(context);
          },
          listener: (context, answerState) {
            if (answerState is AnswerAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Answer added successfully')),
              );
              context.read<AnswerBloc>().add(GetAnswerEvent(widget.questionId));
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.of(context).pop();
              });
            } else if (answerState is AnswerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorsnackBar('Try again later'),
              );
            }
          },
        );
      },
    );
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 40,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Answer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                    const SnackBar(content: Text('Please fill in all fields.')),
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
