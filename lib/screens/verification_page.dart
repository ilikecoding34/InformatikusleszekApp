import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:blog/widgets/number_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({Key? key, required this.lateverification})
      : super(key: key);

  final bool lateverification;

  final TextEditingController _email = TextEditingController();

  List<TextEditingController> controllerArray = [
    TextEditingController(text: '\u200b'),
    TextEditingController(text: '\u200b'),
    TextEditingController(text: '\u200b'),
    TextEditingController(text: '\u200b'),
  ];

  List<FocusNode> focusnodeArray = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  String code = '';
  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthService>(context).getVerification) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Provider.of<AuthService>(context, listen: false).verificationdone =
            false;
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
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Provider.of<AuthService>(context).getVerification
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        color: Colors.cyan, child: const Text('Jóváhagyva')))
                : const SizedBox.shrink(),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Visszaigazoló email elküldve'),
            ),
            Visibility(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: InputFieldWidget(
                      controller: _email,
                      title: "Email",
                      type: TextInputType.emailAddress)),
              visible: lateverification,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: NumberBox(
                            focus: i == 0 ? true : null,
                            controller: controllerArray[i],
                            prevfocusnode: i > 0 ? focusnodeArray[i - 1] : null,
                            currentfocusnode: focusnodeArray[i],
                            nextfocusnode: i < 3 ? focusnodeArray[i + 1] : null,
                            size: UIconfig.boxWidth,
                          )),
                    IconButton(
                        onPressed: () {
                          for (var item in controllerArray) {
                            item.text = '\u200b';
                          }
                          FocusScope.of(context)
                              .requestFocus(focusnodeArray[0]);
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: UIconfig.buttonBasicStyle,
                onPressed: () async {
                  code = '';
                  for (var item in controllerArray) {
                    code += item.text;
                  }
                  lateverification
                      ? await Provider.of<AuthService>(context, listen: false)
                          .lateVerification(code, _email.text)
                      : await Provider.of<AuthService>(context, listen: false)
                          .verification(code);
                },
                child: const Text('Küldés')),
          ],
        ))));
  }
}
