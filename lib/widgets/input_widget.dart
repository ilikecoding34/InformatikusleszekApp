import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  InputFieldWidget(
      {Key? key,
      required this.controller,
      required this.title,
      this.enable = true})
      : super(key: key);

  final TextEditingController controller;
  final String title;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          maxLines: null,
          enabled: enable,
          controller: controller,
          decoration: InputDecoration(
              labelText: title,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.lime),
                borderRadius: BorderRadius.circular(15),
              )),
        ));
  }
}
