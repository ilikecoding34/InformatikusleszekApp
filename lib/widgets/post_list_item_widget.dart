import 'package:blog/models/post_model.dart';
import 'package:blog/widgets/post_item_body_widget.dart';
import 'package:flutter/material.dart';

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
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          color: Colors.green,
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
