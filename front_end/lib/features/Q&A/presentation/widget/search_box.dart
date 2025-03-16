import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;

  const SearchInputField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.top * 0.3,
        left: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.02,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'What do you want to ask?',
          hintStyle: TextStyle(color: Color(0xff08E0EEA)),
          prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
          filled: true,
          fillColor: Color.fromARGB(255, 226, 225, 225),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
