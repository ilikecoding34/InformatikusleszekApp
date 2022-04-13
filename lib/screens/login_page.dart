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
            const Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 50,
                ),
                child: Text('Informatikusleszek.hu',
                    style: TextStyle(fontSize: 30.0))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.lime),
                              borderRadius: BorderRadius.circular(15),
                            )),
                      )),
                  visible: !loggedin,
                ),
                Visibility(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                      child: TextField(
                        obscureText: true,
                        controller: _password,
                        decoration: InputDecoration(
                            labelText: 'Jelszó',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.lime),
                              borderRadius: BorderRadius.circular(15),
                            )),
                      )),
                  visible: !loggedin,
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
                            fontSize: 30, fontWeight: FontWeight.bold)),
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
                            style: TextStyle(fontSize: UIconfig.mySize)))
              ],
            )
          ],
        )));
  }
}
