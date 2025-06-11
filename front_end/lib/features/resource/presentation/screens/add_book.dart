import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/data/model/book_model.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController imageController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController titleController = TextEditingController();
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
  Future<String> _getTherapistId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      print('userMap in _getTherapistId: $userMap');
      return userMap['_id'] ?? '';
    }
    print('No user profile found in shared preferences (id)');
    return '';
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

  void _uploadBook(BuildContext context) async {
    final ownerId = await _getTherapistId();
    final uploadedBook = BookModel(
        id: '',
        title: titleController.text,
        type: 'Book',
        author: authorController.text,
        image: _imageUrl!,
        categories: selectedCategories,
        ownerId:ownerId,
        );
    print(uploadedBook);

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
          Navigator.of(context).pop();
          context.read<BookBloc>().add(GetBookEvent());
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
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 10),
              if (_imageFile != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
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
                height: 7,
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
                text: "Upload Book",
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      authorController.text.isNotEmpty) {
                    await _uploadImage();
                    _uploadBook(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
