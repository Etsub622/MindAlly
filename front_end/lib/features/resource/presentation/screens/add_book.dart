import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/bloc_providers.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/data/model/book_model.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController imageController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  // Pick images from the device
  List<File> _imageFiles = [];
  final List<String> _imageUrls = [];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      }
    });
  }

  // image uploading to cloudinary
  Future<void> _uploadImages() async {
    for (var imageFile in _imageFiles) {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dzfbycabj/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'imagePreset'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = json.decode(responseString);
        final url = jsonMap['url'];
        _imageUrls.add(url);
      } else {
        print('Failed to upload image');
      }
    }
  }

  void _uploadBook(BuildContext context) async {
    final uploadedBook = BookModel(
        id: '',
        title: titleController.text,
        author: authorController.text,
        image: _imageUrls[0]);
    context.read<BookBloc>().add(AddBookEvent(uploadedBook));
  }

  @override
  void dispose() {
    imageController.dispose();
    authorController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const CircularIndicator();
        } else {
          return _buildForm(context);
        }
      },
      listener: (context, state) {
        if (state is BookAdded) {
          const snack = SnackBar(content: Text('Book added successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        } else if (state is BookError) {
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
            child: Text('Add Books',
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
            CustomFormField(text: 'author', controller: authorController),
            SizedBox(
              height: 40,
            ),
            CustomButton(
              wdth: double.infinity,
              rad: 10,
              hgt: 50,
              text: "Upload Book",
              onPressed: () async {
                if (_imageFiles.isNotEmpty &&
                    titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty) {
                  await _uploadImages().then((_) {
                    _uploadBook(context);
                  });
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
