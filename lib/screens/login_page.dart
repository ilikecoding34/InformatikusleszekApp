import 'package:blog/config/ui_config.dart';
import 'package:blog/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Visibility(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  )),
              visible: !loggedin,
            ),
            Visibility(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    obscureText: true,
                    controller: _password,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jelszó',
                    ),
                  )),
              visible: !loggedin,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: 300.0,
                height: 100.0,
                child: ElevatedButton(
                    onPressed: () async {
                      Map creds = {
                        'email': _email.text,
                        'password': _password.text,
                      };
                      await Provider.of<AuthService>(context, listen: false)
                          .login(creds: creds)
                          .then((value) => {Navigator.pop(context)});
                    },
                    child: loggedin
                        ? const Text('Belépve')
                        : const Text('Belépés',
                            style: TextStyle(fontSize: UIconfig.mySize))))
          ],
        )));
  }
}
