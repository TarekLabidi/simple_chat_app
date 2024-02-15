import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 159, 157, 157))),
    );
  }
}
