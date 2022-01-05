// ----------------------------------------------------
// ----------Código principal para Henutsen------------
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:prueba_wl/login.dart';

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

    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const LoginPage(),
        //'/menu': (context) => const MenuPage(),
      },
    );
  }
}
