import 'package:flutter/material.dart';

class CommentIconButton extends StatelessWidget {
  const CommentIconButton(
      {Key? key, required this.icon, this.datas, required this.action})
      : super(key: key);

  final Map? datas;
  final Future action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(icon),
        onPressed: () async {
          await action;
        });
  }
}
