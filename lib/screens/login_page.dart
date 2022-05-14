import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/verification_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _email;
  late TextEditingController _name;
  late TextEditingController _password;
  bool namevisible = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool reg = Provider.of<AuthService>(context, listen: true).bregistration;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: reg ? Colors.cyan : Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: UIconfig.mySize,
                                fontWeight: FontWeight.bold)),
                        onPressed: () => {
                              Provider.of<AuthService>(context, listen: false)
                                  .changeToLogin(),
                              namevisible = false,
                            },
                        child: const Text('Bejelentkezés'))),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: reg ? Colors.lightGreen : Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: UIconfig.mySize,
                                fontWeight: FontWeight.bold)),
                        onPressed: () =>
                            Provider.of<AuthService>(context, listen: false)
                                .changeToReg(),
                        child: const Text('Regisztráció'))),
              ],
            ),
            Visibility(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerificationScreen(
                                    lateverification: true,
                                  )),
                        );
                      },
                      child: const Text('Email cím megerősítés'))),
              visible: !loggedin && namevisible,
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedContainer(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    duration: const Duration(milliseconds: 500),
                    onEnd: () => setState(() {
                          reg ? namevisible = true : namevisible = false;
                        }),
                    height: reg ? 300 : 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          child: const Text('Email elküldve'),
                          visible:
                              Provider.of<AuthService>(context, listen: true)
                                  .verificationsent,
                        ),
                        Visibility(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextField(
                                controller: _name,
                                decoration: InputDecoration(
                                    labelText: 'Név',
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
                          visible: !loggedin && namevisible,
                        ),
                        Visibility(
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                        reg
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  Map creds = {
                                    'email': _email.text,
                                    'name': _name.text,
                                    'password': _password.text,
                                  };

                                  await Provider.of<AuthService>(context,
                                          listen: false)
                                      .registration(creds: creds);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerificationScreen(
                                              lateverification: false,
                                            )),
                                  );
                                },
                                child: loggedin
                                    ? const Text('Belépve')
                                    : const Text('Regisztráció',
                                        style: TextStyle(
                                            fontSize: UIconfig.mySize)))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  Map creds = {
                                    'email': _email.text,
                                    'password': _password.text,
                                  };
                                  await Provider.of<AuthService>(context,
                                          listen: false)
                                      .login(creds: creds)
                                      .then(
                                          (value) => {Navigator.pop(context)});
                                },
                                child: loggedin
                                    ? const Text('Belépve')
                                    : const Text('Belépés',
                                        style: TextStyle(
                                            fontSize: UIconfig.mySize))),
                      ],
                    )))
          ],
        )));
  }
}
