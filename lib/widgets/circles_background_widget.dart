import 'package:blog/widgets/circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CirclesBackground extends StatefulWidget {
  const CirclesBackground({Key? key}) : super(key: key);

  @override
  State<CirclesBackground> createState() => _CirclesBackgroundState();
}

class _CirclesBackgroundState extends State<CirclesBackground> {
  List<Circle> circles = [];
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ...circles,
      Circle(onFinished: (val) {
        setState(() {
          for (int i = 0; i < 50; i++) {
            circles.add(const Circle());
          }
        });
      }),
    ]);
  }
}
