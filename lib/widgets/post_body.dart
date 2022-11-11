import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/cupertino.dart';

class PostBody extends StatelessWidget {
  const PostBody(
      {Key? key,
      required this.titlectrl,
      required this.urctrl,
      required this.contentctrl})
      : super(key: key);

  final TextEditingController titlectrl;
  final TextEditingController urctrl;
  final TextEditingController contentctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InputFieldWidget(
              title: 'Cím', controller: titlectrl, type: TextInputType.text),
          InputFieldWidget(
              title: 'Url - opcionális',
              controller: urctrl,
              type: TextInputType.url),
          InputFieldWidget(
              title: 'Tartalom',
              controller: contentctrl,
              type: TextInputType.multiline),
        ],
      ),
    );
  }
}
