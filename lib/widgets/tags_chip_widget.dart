import 'package:blog/services/post_service.dart';
import 'package:blog/widgets/selected_chips_widget.dart';
import 'package:flutter/material.dart';

class TagsChip extends StatelessWidget {
  final PostService post;

  const TagsChip({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SelectedChips(
          post: post,
          tagname: 'Mind',
          selected: false,
        ),
        ...post.getAllTags.map(
          (tag) {
            return SelectedChips(
              post: post,
              tagname: tag.name,
              selected: post.tagFilterList.contains(tag.name) ? true : false,
            );
          },
        ),
      ],
    );
  }
}
