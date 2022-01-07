// ----------------------------------------------------
// -------Base de aplicación y manejo de rutas---------
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/login.dart';
import 'package:prueba_wl/homepage.dart';
import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/provider/user.dart';

void main() {
  runApp(const MyApp());
}

/// Clase principal
class MyApp extends StatelessWidget {
  ///  Class Key
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Prueba WL';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SpotifyModel(),
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          highlightColor: const Color.fromRGBO(238, 119, 126, 1),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
