import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/verification_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/widgets/animated_border_widget.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

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
    // TODO: implement initState
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

  loginValidated() {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbarLoginDone)
        .closed
        .then((value) => Navigator.pop(context));
  }

  loginFailed() {
    ScaffoldMessenger.of(context).showSnackBar(snackbarLoginFail);
  }

  invalidMail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Rossz emailcím'),
      ),
    );
    return;
  }

  final snackbarLoginDone = const SnackBar(
    duration: Duration(milliseconds: 500),
    behavior: SnackBarBehavior.floating,
    content: Text('Sikeres belépés'),
  );

  final snackbarLoginFail = const SnackBar(
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    content: Text('Belépés sikertelen'),
  );

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    bool reg = Provider.of<AuthService>(context, listen: true).bregistration;
    bool loggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bejelentkezés'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
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
                      style: UIconfig.buttonBasicStyle,
                      onPressed: () => {
                            authService.changeToLogin(),
                            namevisible = false,
                          },
                      child: const Text('Bejelentkezés',
                          style: TextStyle(fontSize: UIconfig.mySize)))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              reg ? Colors.lightGreen : Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          textStyle: const TextStyle(
                              fontSize: UIconfig.mySize,
                              fontWeight: FontWeight.bold)),
                      onPressed: () => authService.changeToReg(),
                      child: const Text('Regisztráció'))),
            ],
          ),
          Visibility(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          AnimatedContainer(
              padding: const EdgeInsets.only(left: 10, right: 10),
              duration: const Duration(milliseconds: 100),
              onEnd: () => setState(() {
                    reg ? namevisible = true : namevisible = false;
                  }),
              height: reg ? 300 : 220,
              child: AnimatedBorder(
                  borderwidth: 10,
                  linewidth: 10,
                  boxradius: 10,
                  boxwidth: MediaQuery.of(context).size.width * 0.9,
                  boxheight: reg ? 300 : 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        child: const Text('Email elküldve'),
                        visible: Provider.of<AuthService>(context, listen: true)
                            .verificationsent,
                      ),
                      Visibility(
                        child: InputFieldWidget(
                          title: 'Név',
                          controller: _name,
                          type: TextInputType.name,
                        ),
                        visible: !loggedin && namevisible,
                      ),
                      Visibility(
                        child: InputFieldWidget(
                            title: 'Email',
                            controller: _email,
                            type: TextInputType.emailAddress),
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
                              style: UIconfig.buttonBasicStyle,
                              onPressed: () async {
                                Map creds = {
                                  'email': _email.text,
                                  'name': _name.text,
                                  'password': _password.text,
                                };

                                if (!isEmail(_email.text)) {
                                  invalidMail();
                                }

                                await authService.registration(creds: creds);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerificationScreen(
                                            lateverification: false,
                                          )),
                                );
                              },
                              child: loggedin
                                  ? const Text('Belépve')
                                  : const Text('Regisztráció',
                                      style:
                                          TextStyle(fontSize: UIconfig.mySize)))
                          : ElevatedButton(
                              style: UIconfig.buttonBasicStyle,
                              onPressed: () async {
                                Map creds = {
                                  'email': _email.text,
                                  'password': _password.text,
                                };
                                dynamic loginresponse =
                                    await authService.login(creds: creds);
                                if (loginresponse == true) {
                                  loginValidated();
                                } else {
                                  loginFailed();
                                }
                              },
                              child: loggedin
                                  ? const Text('Belépve')
                                  : const Text('Belépés',
                                      style: TextStyle(
                                          fontSize: UIconfig.mySize))),
                    ],
                  ))),
        ])));
  }
}
