import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateArticle extends StatefulWidget {
  final String id;
  final String content;
  final String title;
  final String link;
  final String logo;

  final Function(Map<String, Object>) onUpdate;

  const UpdateArticle({
    super.key,
    required this.id,
    required this.content,
    required this.link,
    required this.logo,
    required this.title,
    required this.onUpdate,
  });

  @override
  State<UpdateArticle> createState() => _UpdateArticleState();
}

class _UpdateArticleState extends State<UpdateArticle> {
  late TextEditingController titleController;
  late TextEditingController linkController;
  late TextEditingController contentController;
  late TextEditingController logoController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    linkController = TextEditingController(text: widget.link);
    logoController = TextEditingController(text: widget.logo);
    contentController = TextEditingController(text: widget.content);
  }

  void UpdateArticle() async {
    await _uploadImage();
    final updatedArticle = ArticleEntity(
        id: '',
        title: titleController.text,
        content: contentController.text,
        link: linkController.text,
        logo: logoController.text,
        type: "Article",
        categories: ['categories', 'categories']);
    context
        .read<ArticleBloc>()
        .add(UpdateArticleEvent(updatedArticle, widget.id));
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
        _imageUrl = '';
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
        body: BlocConsumer<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state is ArticleUpdated) {
          final snack = snackBar('Article successfully Updated!');
          ScaffoldMessenger.of(context).showSnackBar(snack);
          Navigator.of(context).pop();
          context.read<ArticleBloc>().add(GetArticleEvent());
        } else if (state is ArticleError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Article update Failed!'),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        if (state is ArticleLoading) {
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
                      width: 60,
                    ),
                    const Text(
                      'Update an article',
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
                      child: const Text('Change logo',
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
                          logoController.text,
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
                CustomFormField(text: 'content', controller: contentController),
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
                        linkController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      UpdateArticle();
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

    contentController.dispose();
    logoController.dispose();

    super.dispose();
  }
}
