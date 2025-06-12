import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionalSignup extends StatefulWidget {
  const ProfessionalSignup({super.key});

  @override
  State<ProfessionalSignup> createState() => _ProfessionalSignupState();
}

class _ProfessionalSignupState extends State<ProfessionalSignup> {
  final _key = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaContloller = TextEditingController();
  final TextEditingController documentController = TextEditingController();

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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    areaContloller.dispose();
    documentController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
        .hasMatch(value)) {
      return 'Password must contain letters, numbers, and a special character';
    }
    return null;
  }

  void _professionalSignUp(BuildContext context) {
    final newUser = ProfessionalSignupModel(
        id: '',
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
        phoneNumber: phoneController.text,
        specialization: areaContloller.text,
        certificate: _imageUrl!);
    context
        .read<AuthBloc>()
        .add(ProfessionalsignUpEvent(professionalSignupEntity: newUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularIndicator();
        } else {
          return _build(context);
        }
      }, listener: (context, state) {
        if (state is AuthSuccess) {
          final snack = snackBar('User created successfully');
          ScaffoldMessenger.of(context).showSnackBar(snack);

          Future.delayed(const Duration(seconds: 2), () {
            context.go(AppPath.therapistOnboard);
          });
        } else if (state is AuthError) {
          final snack = errorsnackBar('Try again later');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      }),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/image/logo.webp',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  text: "full name",
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "email",
                    controller: emailController,
                    validator: _validateEmail),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "password",
                    sign: const Icon(Icons.remove_red_eye),
                    controller: passwordController,
                    isPassword: true,
                    validator: _validatePassword),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "confirm password",
                    sign: const Icon(Icons.remove_red_eye),
                    controller: confirmPasswordController,
                    isPassword: true),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  text: "Phone Number",
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  text: "Area of Specialization",
                  controller: areaContloller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area of specialization is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff807C8B),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_imageFile == null)
                        Text(
                          'Upload your certified document',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else
                        Text(
                          'Change your certified document',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _pickImage(ImageSource.gallery);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 33,
                              color: Color(0xff800080),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  wdth: double.infinity,
                  rad: 10,
                  hgt: 50,
                  text: "Sign Up",
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        if (_imageFile == null) {
                          final snack = errorsnackBar(
                              'Please upload your certified document');
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                          return;
                        }
                        await _uploadImage();
                        if (_imageUrl == null) {
                          final snack = errorsnackBar('Image upload failed');
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                          return;
                        }
                        _professionalSignUp(context);
                      } else {
                        final snack = errorsnackBar('Password does not match');
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      context.go(AppPath.login);
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color(0xffB57EDC),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
