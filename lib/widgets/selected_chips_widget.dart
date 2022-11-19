import 'package:blog/models/tag_model.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              elevation: 10.0,
              shadowColor: Provider.of<ThemeService>(context).isDarkMode()
                  ? const ColorScheme.light().background.withOpacity(0.4)
                  : const ColorScheme.dark().background.withOpacity(0.8),
              backgroundColor: Provider.of<ThemeService>(context).isDarkMode()
                  ? const ColorScheme.dark().background.withOpacity(0.1)
                  : const ColorScheme.light().background.withOpacity(0.8),
              onDeleted:
                  selected ? () => post.filterPosts(tag.name, tag.id) : null,
              label: Text(
                tag.name,
                style: TextStyle(
                    color: post.tagFilterList.contains(tag.name)
                        ? Colors.blue
                        : Provider.of<ThemeService>(context).isDarkMode()
                            ? const ColorScheme.light().background
                            : const ColorScheme.dark().background),
              ),
            )));
  }
}
