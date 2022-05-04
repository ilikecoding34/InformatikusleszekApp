import 'package:blog/screens/postlist_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({Key? key}) : super(key: key);

  TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Verification mail sent'),
            Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: code,
                  decoration: InputDecoration(
                      labelText: 'Verification code',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.lime),
                        borderRadius: BorderRadius.circular(15),
                      )),
                )),
            ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthService>(context, listen: false)
                      .verification(code.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostListScreen(title: 'Bejegyzés lista')),
                  );
                },
                child: const Text('Küldés'))
          ],
        ));
  }
}
