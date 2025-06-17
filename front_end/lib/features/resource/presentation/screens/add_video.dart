import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/data/model/video_model.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController imageController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<String> selectedCategories = [];
  File? _imageFile;
  String? _imageUrl;
  String? profilePicture;
  String? therapistId;
  String? therapistName;

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
    return profilePicture ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dzfbycabj/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'imagePreset'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = json.decode(responseString);
      setState(() {
        _imageUrl = jsonMap['url'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorsnackBar('Failed to upload image'),
      );
    }
  }

  void _uploadVideo(BuildContext context) async {
    if (_imageUrl == null || profilePicture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorsnackBar('Please upload an image and wait for profile data'),
      );
      return;
    }
    final ownerId = await _getTherapistId();
    final name = await _getTherapistName();
    final profilePic = await _getTherapistProfile();
    final uploadedVideo = VideoModel(
      id: '',
      type: "Video",
      title: titleController.text,
      link: linkController.text,
      profilePicture: profilePic,
      name: name,
      ownerId: ownerId,
      image: _imageUrl!,
      categories: selectedCategories,
    );
    context.read<VideoBloc>().add(AddVideoEvent(uploadedVideo));
  }

  @override
  void dispose() {
    imageController.dispose();
    titleController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TherapistProfileBloc, GetTherapistState>(
        listener: (context, state) {
          if (state is GetTherapistLoaded) {
            setState(() {
              profilePicture = state.therapist.profilePicture ?? '';
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
          return BlocConsumer<VideoBloc, VideoState>(
            builder: (context, videoState) {
              if (videoState is VideoLoading) {
                return const CircularIndicator();
              }
              return _buildForm(context);
            },
            listener: (context, videoState) {
              if (videoState is VideoAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video added successfully')),
                );
                Navigator.of(context).pop();
                context.read<VideoBloc>().add(GetVideoEvent());
              } else if (videoState is VideoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorsnackBar('Try again later'),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Video',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff800080),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Select Image'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Icon(
                  Icons.add_a_photo,
                  size: 33,
                  color: Color(0xff800080),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_imageFile != null)
              Container(
                height: 200,
                width: double.infinity,
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),
            CustomFormField(text: 'Title', controller: titleController),
            const SizedBox(height: 15),
            CustomFormField(text: 'Link', controller: linkController),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                buttonText: const Text('Video Category'),
                title: const Text('Video Category'),
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
            const SizedBox(height: 40),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Upload Video",
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    linkController.text.isNotEmpty &&
                    _imageFile != null) {
                  await _uploadImage();
                  _uploadVideo(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    errorsnackBar('Please fill all fields and select an image'),
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
