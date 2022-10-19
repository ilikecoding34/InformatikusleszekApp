import 'package:blog/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentShow extends StatelessWidget {
  const CommentShow({
    Key? key,
    required this.show,
  }) : super(key: key);

  final bool show;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            child: const Text('Kommentek:', style: TextStyle(fontSize: 15.0))),
        ElevatedButton(
            onPressed: () => Provider.of<PostService>(context, listen: false)
                .changecollapse(),
            child: show ? const Text('Kinyit') : const Text('Összecsuk'))
      ],
    );
  }
}
