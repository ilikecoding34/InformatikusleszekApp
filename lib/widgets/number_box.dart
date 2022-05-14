import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberBox extends StatefulWidget {
  const NumberBox({
    Key? key,
    this.focus,
    required this.controller,
    this.prevfocusnode,
    required this.currentfocusnode,
    this.nextfocusnode,
    required this.size,
  }) : super(key: key);

  final bool? focus;
  final TextEditingController controller;
  final FocusNode? prevfocusnode;
  final FocusNode currentfocusnode;
  final FocusNode? nextfocusnode;
  final double size;

  @override
  State<NumberBox> createState() => _NumberBoxState();
}

class _NumberBoxState extends State<NumberBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          color: widget.controller.text != '\u200b' &&
                  widget.controller.text.isNotEmpty
              ? Colors.green
              : Colors.green.shade100,
        ),
        width: widget.size,
        child: TextField(
          autofocus: widget.focus != null,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            LengthLimitingTextInputFormatter(1),
          ],
          textAlign: TextAlign.center,
          controller: widget.controller,
          focusNode: widget.currentfocusnode,
          onChanged: (String value) {
            setState(() {
              if (value.length == 1 && widget.nextfocusnode != null) {
                FocusScope.of(context).requestFocus(widget.nextfocusnode);
              }
              if (value.isEmpty && widget.prevfocusnode != null) {
                FocusScope.of(context).requestFocus(widget.prevfocusnode);
                widget.controller.text = '\u200b';
              }
            });
          },
        ));
  }
}
