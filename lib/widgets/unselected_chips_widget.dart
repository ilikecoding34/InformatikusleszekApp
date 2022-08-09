import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';

class UnselectedChips extends StatelessWidget {
  const UnselectedChips({
    Key? key,
    required this.post,
    required this.tagname,
  }) : super(key: key);

  final PostService post;
  final String tagname;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          post.filterPosts(tagname);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, top: 5.0),
          child: Chip(
            label: Text(
              tagname,
              style: TextStyle(
                  color: post.tagFilterList.contains(tagname)
                      ? Colors.blue
                      : Colors.white),
            ),
          ),
        ));
  }
}
