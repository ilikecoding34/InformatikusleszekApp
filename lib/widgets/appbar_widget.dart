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
    return PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: themeNotifier.isDarkMode()
                  ? const ColorScheme.light().background
                  : const ColorScheme.dark().background,
            )),
        constraints: const BoxConstraints(minWidth: 2.0 * 30.0),
        color: themeNotifier.isDarkMode()
            ? const ColorScheme.dark().background.withAlpha(150)
            : const ColorScheme.light().primaryContainer.withAlpha(150),
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: themeNotifier.isDarkMode()
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
            ),
            if (isloggedin)
              const PopupMenuItem<int>(
                value: 1,
                child: Icon(Icons.playlist_add_outlined),
              ),
            PopupMenuItem<int>(
                value: 2,
                child: isloggedin
                    ? const Icon(Icons.logout)
                    : const Icon(Icons.login)),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            bool value = !themeNotifier.isDarkMode();
            themeNotifier.changeMode(value);
          } else if (value == 1) {
            Provider.of<PostService>(context, listen: false)
                .clearTagFilterList();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPostPage(pagetitle: 'Új bejegyzés')),
            );
          } else if (value == 2) {
            isloggedin
                ? Provider.of<AuthService>(context, listen: false)
                    .logout()
                    .then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(snackbarLogoutDone))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
          }
        });
  }
}
