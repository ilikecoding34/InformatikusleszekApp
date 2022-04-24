import 'package:blog/models/post_model.dart';
import 'package:flutter/material.dart';

class PostListItemBody extends StatelessWidget {
  const PostListItemBody({
    Key? key,
    required this.postitem,
  }) : super(key: key);

  final PostModel postitem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(postitem.title,
              style: TextStyle(
                fontSize: 20.0,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.black,
              )),
        ),
        Text(postitem.user!.name),
      ],
    );
  }
}
