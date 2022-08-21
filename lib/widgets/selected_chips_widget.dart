import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';

class SelectedChips extends StatelessWidget {
  const SelectedChips({
    Key? key,
    required this.post,
    required this.tagname,
    required this.selected,
  }) : super(key: key);

  final PostService post;
  final String tagname;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          post.filterPosts(tagname);
        },
        child: Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 5.0),
            child: Chip(
              onDeleted: selected ? () => post.filterPosts(tagname) : null,
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
