import 'package:blog/config/ui_config.dart';
import 'package:blog/models/post_model.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewComment extends StatelessWidget {
  const NewComment({
    Key? key,
    required this.newcommentcontroller,
    required this.getpost,
    required this.action,
  }) : super(key: key);

  final TextEditingController newcommentcontroller;
  final PostModel getpost;
  final Future action;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: InputFieldWidget(
            controller: newcommentcontroller, title: 'Új hozzászólás'),
      ),
      Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              style: UIconfig.buttonBasicStyle,
              onPressed: () async {
                action;
              },
              child: const Text('Hozzászólás mentése',
                  style: TextStyle(fontSize: UIconfig.mySize))))
    ]);
  }
}
