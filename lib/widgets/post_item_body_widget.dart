import 'package:blog/models/post_model.dart';
import 'package:blog/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListItemBody extends StatelessWidget {
  const PostListItemBody({
    Key? key,
    required this.postitem,
  }) : super(key: key);

  final PostModel postitem;

  @override
  Widget build(BuildContext context) {
    double screenwith = MediaQuery.of(context).size.width * 0.5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: screenwith,
                child: Text(postitem.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Provider.of<ThemeService>(context).isDarkMode()
                            ? Colors.black
                            : Colors.black))),
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              width: screenwith,
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
            Text(postitem.user!.name,
                style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 10),
            Text(postitem.created.substring(0, 10),
                style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 10),
            Text('Megtekintés: ${postitem.view}',
                style: const TextStyle(color: Colors.black)),
          ],
        )
      ],
    );
  }
}
