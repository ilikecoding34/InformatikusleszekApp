import 'dart:math';

import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final Function(bool)? onFinished;
  const Circle({Key? key, this.onFinished}) : super(key: key);

  @override
  State<Circle> createState() => _CircleState();
}

class _CircleState extends State<Circle> with SingleTickerProviderStateMixin {
  var rng = Random();
  var rngsize = Random();
  double left = 0.0;
  double size = 0.0;
  bool visible = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(left, 100),
    end: Offset(left, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    super.initState();
    left = rng.nextDouble() * 200;
    size = rngsize.nextDouble() * 10;
    Future.delayed(Duration(milliseconds: rng.nextInt(1000) * 5), () {
      setState(() {
        visible = true;
      });
      _controller.forward().whenComplete(() {
        if (widget.onFinished != null) {
          widget.onFinished!(true);
        }
        setState(() {
          visible = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: size,
                  spreadRadius: size,
                ),
              ],
            ),
          ),
        ),
        visible: visible);
  }
}
