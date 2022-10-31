import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBorder extends StatefulWidget {
  const AnimatedBorder(
      {Key? key,
      required this.borderwidth,
      required this.linewidth,
      required this.boxradius,
      required this.boxwidth,
      required this.boxheight,
      required this.child})
      : super(key: key);

  final double borderwidth;
  final double boxwidth;
  final double boxradius;
  final double boxheight;
  final double linewidth;
  final Widget child;

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double linesize = widget.boxheight >= widget.boxwidth
        ? widget.boxheight * 1.4
        : widget.boxwidth * 1.4;
    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.boxradius),
        child: Container(
            width: widget.boxwidth,
            height: widget.boxheight,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  color: Colors.grey.shade400,
                  width: widget.boxwidth,
                  height: widget.boxheight,
                ),
              ),
              Positioned(
                top: (widget.boxheight - linesize) / 2,
                left: (widget.boxwidth - linesize) / 2,
                child: Container(
                  width: linesize,
                  height: linesize,
                  child: RotationTransition(
                    turns: _animation,
                    child: Stack(children: [
                      Container(
                        width: linesize,
                        height: linesize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const SweepGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                      ),
                      Transform.rotate(
                          angle: -math.pi,
                          child: Container(
                            width: linesize,
                            height: linesize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const SweepGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black,
                                ],
                                stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                          ))
                    ]),
                  ),
                ),
              ),
              Positioned(
                top: (widget.borderwidth / 2) - 1,
                left: (widget.borderwidth / 2) - 1,
                child: Container(
                  width: widget.boxwidth - widget.borderwidth,
                  height: widget.boxheight - widget.borderwidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.boxradius),
                    color: Colors.grey.shade800,
                  ),
                  child: widget.child,
                ),
              ),
            ])));
  }
}
