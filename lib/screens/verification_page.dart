import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/widgets/number_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({Key? key}) : super(key: key);

  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();

  FocusNode textFirstFocusNode = FocusNode();
  FocusNode textSecondFocusNode = FocusNode();
  FocusNode textThirdFocusNode = FocusNode();
  FocusNode textFourthFocusNode = FocusNode();

  String code = '';
  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthService>(context).getVerification) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostListScreen(title: 'Bejegyzés lista')),
        );
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Provider.of<AuthService>(context).getVerification
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        color: Colors.cyan, child: const Text('Jóváhagyva')))
                : const Text(''),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Visszaigazoló email elküldve'),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow.shade200,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: NumberBox(
                          focus: true,
                          controller: first,
                          currentfocusnode: textFirstFocusNode,
                          nextfocusnode: textSecondFocusNode,
                          size: UIconfig.boxWidth,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: NumberBox(
                          controller: second,
                          prevfocusnode: textFirstFocusNode,
                          currentfocusnode: textSecondFocusNode,
                          nextfocusnode: textThirdFocusNode,
                          size: UIconfig.boxWidth,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: NumberBox(
                          controller: third,
                          prevfocusnode: textSecondFocusNode,
                          currentfocusnode: textThirdFocusNode,
                          nextfocusnode: textFourthFocusNode,
                          size: UIconfig.boxWidth,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: NumberBox(
                          controller: fourth,
                          prevfocusnode: textThirdFocusNode,
                          currentfocusnode: textFourthFocusNode,
                          size: UIconfig.boxWidth,
                        )),
                    IconButton(
                        onPressed: () {
                          first.clear();
                          second.clear();
                          third.clear();
                          fourth.clear();
                          FocusScope.of(context)
                              .requestFocus(textFirstFocusNode);
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: UIconfig.mySize,
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  code =
                      '${first.text}${second.text}${third.text}${fourth.text}';
                  await Provider.of<AuthService>(context, listen: false)
                      .verification(code);
                },
                child: const Text('Küldés')),
          ],
        ));
  }
}
