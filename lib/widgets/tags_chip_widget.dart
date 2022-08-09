import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/selected_chips_widget.dart';
import 'package:blog/widgets/unselected_chips_widget.dart';
import 'package:flutter/material.dart';

class TagsChip extends StatelessWidget {
  final PostService post;

  const TagsChip({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0.0,
      spacing: 10.0,
      children: [
        GestureDetector(
            onTap: () {
              post.filterPosts('all');
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 5.0),
                child: Chip(
                  label: Text(
                    "Mind",
                    style: TextStyle(
                        color: post.tagFilterList.isEmpty
                            ? Colors.blue
                            : Colors.white),
                  ),
                ))),
        for (var item in post.getAllTags)
          post.tagFilterList.contains(item.name)
              ? const SizedBox.shrink()
              : UnselectedChips(post: post, tagname: item.name),
        for (var tag in post.tagFilterList)
          SelectedChips(post: post, tagname: tag),
      ],
    );
  }
}
