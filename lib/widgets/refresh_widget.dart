import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RefreshList extends StatelessWidget {
  const RefreshList(
      {Key? key,
      required this.swiped,
      required this.numberOfLines,
      required this.evenOrOdd})
      : super(key: key);

  final double swiped;
  final int numberOfLines;
  final bool evenOrOdd;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: (swiped < 0) ? 0 : swiped / 100,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                height: 50,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < numberOfLines; i++)
                          RotationTransition(
                              turns: const AlwaysStoppedAnimation(45 / 360),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 50,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: (evenOrOdd ? i.isEven : i.isOdd)
                                          ? Colors.blue
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Frissítés',
                            style: TextStyle(backgroundColor: Colors.grey),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(swiped / 100),
                            child: const Icon(Icons.autorenew),
                          )
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
