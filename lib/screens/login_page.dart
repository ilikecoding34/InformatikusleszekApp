import 'package:blog/config/ui_config.dart';
import 'package:blog/screens/verification_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
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
                        style: UIconfig.buttonBasicStyle,
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
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                            width: 250,
                            height: 250,
                            child: Stack(children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  color: Colors.black12,
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: -120,
                                child: Container(
                                  width: 500,
                                  height: 100,
                                  child: RotationTransition(
                                    turns: _animation,
                                    child: Stack(children: [
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: 250,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black
                                                ],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topLeft,
                                              )))),
                                      Positioned(
                                          top: 50,
                                          left: 250,
                                          child: Container(
                                              width: 250,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomLeft,
                                              )))),
                                    ]),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                  child: AnimatedContainer(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      onEnd: () => setState(() {
                                            reg
                                                ? namevisible = true
                                                : namevisible = false;
                                          }),
                                      height: reg ? 300 : 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            child: const Text('Email elküldve'),
                                            visible: Provider.of<AuthService>(
                                                    context,
                                                    listen: true)
                                                .verificationsent,
                                          ),
                                          Visibility(
                                            child: InputFieldWidget(
                                                title: 'Név',
                                                controller: _name),
                                            visible: !loggedin && namevisible,
                                          ),
                                          Visibility(
                                            child: InputFieldWidget(
                                                title: 'Email',
                                                controller: _email),
                                            visible: !loggedin,
                                          ),
                                          Visibility(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 20, 10),
                                                child: TextField(
                                                  obscureText: true,
                                                  controller: _password,
                                                  decoration: InputDecoration(
                                                      labelText: 'Jelszó',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 3,
                                                                color: Colors
                                                                    .blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 3,
                                                                color: Colors
                                                                    .lime),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      )),
                                                )),
                                            visible: !loggedin,
                                          ),
                                          reg
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.cyan,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 50,
                                                              vertical: 20),
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                  onPressed: () async {
                                                    Map creds = {
                                                      'email': _email.text,
                                                      'name': _name.text,
                                                      'password':
                                                          _password.text,
                                                    };

                                                    if (!isEmail(_email.text)) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          content: Text(
                                                              'Rossz emailcím'),
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    await Provider.of<
                                                                AuthService>(
                                                            context,
                                                            listen: false)
                                                        .registration(
                                                            creds: creds);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VerificationScreen(
                                                                lateverification:
                                                                    false,
                                                              )),
                                                    );
                                                  },
                                                  child: loggedin
                                                      ? const Text('Belépve')
                                                      : const Text('Regisztráció',
                                                          style: TextStyle(
                                                              fontSize: UIconfig
                                                                  .mySize)))
                                              : ElevatedButton(
                                                  style:
                                                      UIconfig.buttonBasicStyle,
                                                  onPressed: () async {
                                                    Map creds = {
                                                      'email': _email.text,
                                                      'password':
                                                          _password.text,
                                                    };
                                                    await Provider.of<
                                                                AuthService>(
                                                            context,
                                                            listen: false)
                                                        .login(creds: creds)
                                                        .then((value) => {
                                                              if (value !=
                                                                      null ||
                                                                  value == true)
                                                                {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackbarLoginDone)
                                                                      .closed
                                                                      .then((value) =>
                                                                          Navigator.pop(
                                                                              context))
                                                                }
                                                              else
                                                                {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackbarLoginFail)
                                                                }
                                                            });
                                                  },
                                                  child: loggedin
                                                      ? const Text('Belépve')
                                                      : const Text('Belépés',
                                                          style: TextStyle(
                                                              fontSize: UIconfig
                                                                  .mySize))),
                                        ],
                                      )),
                                ),
                              ),
                            ])))))
          ],
        )));
  }
}
