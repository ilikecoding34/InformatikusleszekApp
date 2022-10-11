import 'package:blog/models/tag_model.dart';
import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';

class SelectedChips extends StatelessWidget {
  const SelectedChips({
    Key? key,
    required this.post,
    required this.tag,
    required this.selected,
  }) : super(key: key);

  final PostService post;
  final TagModel tag;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          post.filterPosts(tag.name, tag.id);
        },
        child: Padding(
            padding: const EdgeInsets.only(right: 5.0, top: 5.0),
            child: Chip(
              onDeleted:
                  selected ? () => post.filterPosts(tag.name, tag.id) : null,
              label: Text(
                tag.name,
                style: TextStyle(
                    color: post.tagFilterList.contains(tag.name)
                        ? Colors.blue
                        : Colors.white),
              ),
            )));
  }
}
