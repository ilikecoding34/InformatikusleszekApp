import 'package:blog/models/post_model.dart';
import 'package:blog/services/theme_service.dart';
import 'package:blog/widgets/post_item_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListItem extends StatelessWidget {
  PostListItem({
    Key? key,
    required this.postitem,
    required this.openitem,
  }) : super(key: key);

  final PostModel postitem;
  VoidCallback openitem;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: Provider.of<ThemeService>(context).isDarkMode()
                  ? [
                      Colors.blueGrey,
                      Colors.blueGrey.shade600,
                      Colors.blueGrey.shade400,
                      Colors.blueGrey.shade100
                    ]
                  : [
                      Colors.blue,
                      Colors.blue.shade600,
                      Colors.blue.shade500,
                      Colors.blue.shade200
                    ]),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () => openitem(),
            child: PostListItemBody(postitem: postitem)));
  }
}
