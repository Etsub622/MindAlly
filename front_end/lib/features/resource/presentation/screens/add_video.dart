import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/bloc_providers.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';

import 'package:front_end/features/resource/data/model/video_model.dart';

import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController imageController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<String> selectedCategories = [];

  List<String> categoryOption = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];

  // Pick images from the device
  File? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  // Image uploading to Cloudinary
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
      print('Failed to upload image');
    }
  }

  void _uploadVideo(BuildContext context) async {
    final uploadedVideo = VideoModel(
        id: '',
        type: "Video",
        title: titleController.text,
        link: linkController.text,
        profilePicture: profilePictureController.text,
        name: nameController.text,
        image: _imageUrl!,
        categories: selectedCategories);
    print(uploadedVideo);

    context.read<VideoBloc>().add(AddVideoEvent(uploadedVideo));
  }

  @override
  void dispose() {
    imageController.dispose();
    nameController.dispose();
    titleController.dispose();
    profilePictureController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return const CircularIndicator();
        } else {
          return _buildForm(context);
        }
      },
      listener: (context, state) {
        if (state is VideoAdded) {
          const snack = SnackBar(content: Text('Video added successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        } else if (state is VideoError) {
          final snack = errorsnackBar('Try again later');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
    ));
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Center(
            child: Text('Add Video',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (Color(0xff800080)),
                )),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('select images'),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 33,
                    color: Color(0xff800080),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 7,
            ),
            CustomFormField(text: 'title', controller: titleController),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 7,
            ),
            CustomFormField(text: 'link', controller: linkController),
            SizedBox(
              height: 15,
            ),
            CustomFormField(
                text: 'profile', controller: profilePictureController),
            SizedBox(
              height: 15,
            ),
            CustomFormField(text: 'name', controller: nameController),
            SizedBox(
              height: 15,
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: MultiSelectDialogField<String>(
                items: categoryOption
                    .map((e) => MultiSelectItem<String>(e, e))
                    .toList(),
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
            SizedBox(
              height: 40,
            ),
            
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Upload Video",
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    profilePictureController.text.isNotEmpty &&
                    linkController.text.isNotEmpty) {
                  _uploadVideo(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
