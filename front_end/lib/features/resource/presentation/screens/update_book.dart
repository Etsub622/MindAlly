import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/widget/custom_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class UpdateBook extends StatefulWidget {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final List<String> categories;
  final Function(Map<String, Object>) onUpdate;

  const UpdateBook({

    super.key,
    required this.id,
    required this.author,
    required this.imageUrl,
    required this.title,
    required this.onUpdate,
    required this.categories,
  });

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController imageController;
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    authorController = TextEditingController(text: widget.author);

    imageController = TextEditingController(text: widget.imageUrl);
    selectedCategories = widget.categories;
  }

  List<String> categoryOption = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];

  void updateBook() async {
    await _uploadImage();
    final updatedbook = BookEntity(
      id: '', 
      image: _imageUrl?.isNotEmpty == true ? _imageUrl! : imageController.text,
      author: authorController.text, 
      title: titleController.text, 
      type: 'Book', 
      categories: selectedCategories,
    );
    print('updatedbook: $updatedbook');
    context.read<BookBloc>().add(UpdateBookEvent(updatedbook, widget.id));
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
        body: BlocConsumer<BookBloc, BookState>(
      listener: (context, state) {
        if (state is BookUpdated) {
          final snack = snackBar('book successfully Updated!');
          ScaffoldMessenger.of(context).showSnackBar(snack);
          Navigator.of(context).pop();
          context.read<BookBloc>().add(GetBookEvent());
        } else if (state is BookError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('book update Failed!'),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        if (state is BookLoading) {
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
                      'Update book',
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
                  child: _imageUrl != null
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
                CustomFormField(text: 'author', controller: authorController),
                const SizedBox(
                  height: 20,
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
                        authorController.text.isNotEmpty) {
                      updateBook();
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
    authorController.dispose();

    imageController.dispose();

    super.dispose();
  }
}
