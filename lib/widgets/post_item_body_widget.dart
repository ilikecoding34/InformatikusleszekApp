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
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: size.width * 0.5,
                child: Text(postitem.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ))),
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              width: size.width * 0.5,
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
        Column(
          children: [
            Text(postitem.user!.name),
            const SizedBox(height: 10),
            Text(postitem.created.substring(0, 10)),
          ],
        )
      ],
    );
  }
}
