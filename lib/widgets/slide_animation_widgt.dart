import 'package:flutter/material.dart';

class SlidingWidget extends StatefulWidget {
  const SlidingWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<StatefulWidget> createState() => SlidingWidgetState();
}

class SlidingWidgetState extends State<SlidingWidget>
    with TickerProviderStateMixin<SlidingWidget> {
  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offsetAnimation, child: widget.child);
  }
}
