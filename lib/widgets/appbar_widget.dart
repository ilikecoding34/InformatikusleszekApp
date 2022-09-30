import 'package:blog/screens/login_page.dart';
import 'package:blog/screens/newpost_page.dart';
import 'package:blog/services/auth_service.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({Key? key}) : super(key: key);

  final snackbarLogoutDone = const SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text('Kiléptél'),
  );

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeService>(context);
    bool isloggedin =
        Provider.of<AuthService>(context, listen: true).authenticated;
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          child: const Text('Mode:'),
        ),
        IconButton(
            onPressed: () {
              bool value = !themeNotifier.getMode();
              themeNotifier.changeMode(value);
            },
            icon: themeNotifier.getMode()
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode)),
        Visibility(
          child: IconButton(
              onPressed: () {
                Provider.of<PostService>(context, listen: false)
                    .clearTagFilterList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewPostPage(pagetitle: 'Új bejegyzés')),
                );
              },
              icon: const Icon(Icons.playlist_add_outlined)),
          visible: isloggedin,
        ),
        Visibility(
          child: IconButton(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logout().then(
                    (value) => ScaffoldMessenger.of(context)
                        .showSnackBar(snackbarLogoutDone));
              },
              icon: const Icon(Icons.logout)),
          replacement: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login)),
          visible: isloggedin,
        ),
      ],
    );
  }
}
