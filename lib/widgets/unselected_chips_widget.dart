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
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
            onTap: () {
              post.filterPosts(tagname);
            },
            child: Chip(
              label: Text(
                tagname,
                style: TextStyle(
                    color: post.tagFilterList.contains(tagname)
                        ? Colors.blue
                        : Colors.white),
              ),
            )));
  }
}
