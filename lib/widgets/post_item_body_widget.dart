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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(postitem.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ))),
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  for (int i = 0; i < postitem.tags.length; i++)
                    Container(
                        color: i % 2 == 0 ? Colors.blue : Colors.lime,
                        child: Text(postitem.tags[i].name)),
                ],
              ),
            )
          ],
        ),
        Text(postitem.user!.name),
      ],
    );
  }
}
