import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;

  const SearchInputField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(238, 239, 227, 248),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'What do you want to ask?',
          hintStyle:
              TextStyle(color: Color.fromARGB(239, 130, 5, 220), fontSize: 16),
          suffixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Color.fromARGB(238, 239, 224, 249),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        style: TextStyle(color: Color.fromARGB(239, 130, 5, 220), fontSize: 16),
      ),
    );
  }
}
