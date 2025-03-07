import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateVideo extends StatefulWidget {
  final String image;
  final String title;
  final String link;
  final String profilePicture;
  final String name;
  final Function(Map<String, Object>) onUpdate;

  const UpdateVideo({
    super.key,
    required this.image,
    required this.link,
    required this.profilePicture,
    required this.name,

    required this.title,
    required this.onUpdate,
  });

  @override
  State<UpdateVideo> createState() => _UpdateVideoState();
}

class _UpdateVideoState extends State<UpdateVideo> {
  late TextEditingController titleController;
  late TextEditingController linkController;
  late TextEditingController profilePictureController;
  late TextEditingController nameController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    linkController = TextEditingController(text: widget.link);
    profilePictureController = TextEditingController(text: widget.profilePicture);
    nameController = TextEditingController(text: widget.name);
    imageController = TextEditingController(text: widget.image);
  }

  void UpdateVideo() async {
    await _uploadImage();
    final Map<String, Object> updatedbook = {
      'title': titleController.text,
      'link': linkController.text,
      'profilePicture': profilePictureController.text,
      'name': nameController.text,
  
      'image': _imageUrl?.isNotEmpty == true ? _imageUrl! : imageController.text,
    };
    widget.onUpdate(updatedbook);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<VideoBloc, VideoState>(
      listener: (context, state) {
        if (state is VideoUpdated) {
          final snack = snackBar('video successfully Updated!');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        } else if (state is VideoError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('video update Failed!'),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        if (state is VideoLoading) {
          return const CircularIndicator();
        } else {
          return _buildForm(context);
        }
      },
    ));
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Color(0xFFB57EDC),
                        size: 22,
                      ),
                    ),
                    const SizedBox(
                      width: 130,
                    ),
                    const Text(
                      'Update video',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3E3E3E),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: const Text('Change image',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF3E3E3E),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: _imageUrl != null && _imageUrl!.isEmpty
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          imageController.text,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormField(text: 'title', controller: titleController),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFormField(text: 'link', controller: linkController),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                  wdth: double.infinity,
                  rad: 10,
                  hgt: 50,
                  text: "Update",
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        linkController.text.isNotEmpty) {
                      UpdateVideo;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    linkController.dispose();
    profilePictureController.dispose();
    nameController.dispose();
    imageController.dispose();

    super.dispose();
  }
}
