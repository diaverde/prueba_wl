// ---------------------------------------------------------------------
// -------------------------Inicio de sesión----------------------------
// ---------------------------------------------------------------------

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/provider/user.dart';

/// Clase principal
class LoginPage extends StatelessWidget {
  ///  Class Key
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _waitAndMove(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba WL'),
      ),
      body: LoginPageDetails(),
    );
  }
}

/// Clase para el login
class LoginPageDetails extends StatelessWidget {
  ///  Class Key
  LoginPageDetails({Key? key}) : super(key: key);

  // Llave para el formulario de captura de datos
  final _formKey = GlobalKey<FormState>();

/*
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
}
*/

  // Método para crear el formulario
  @override
  Widget build(BuildContext context) {
    // Capturar información de usuario
    final user = context.watch<UserModel>();

    return ListView(
      children: [
        // Formulario
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: const Text(
                  'Inicio de sesión',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // Nombre de usuario
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Correo electrónico'),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[\n\t\r]'))
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el correo';
                        } else if (!EmailValidator.validate(value.trim())) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        user.loginUserName = value.toLowerCase().trim();
                      },
                    ),
                  )
                ]),
              ),
              // Contraseña
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contraseña',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[\n\t\r]'))
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese contraseña';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        user.loginPassword = value;
                      },
                    ),
                  ),
                ]),
              ),
              // Botón de ingreso
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                alignment: Alignment.centerRight,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validar
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      user.authMethod = AuthenticationMethod.standard;
                      await user.loadUser();
                    }
                  },
                  child: const Text('Ingresar'),
                ),
              ),
            ],
          ),
        ),
        // Otras opciones
        const Divider(
          height: 5,
        ),
        Column(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: const Text(
                'O utilice sus credenciales:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: SignInButton(
                Buttons.Google,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                text: "Iniciar sesión\ncon Google",
                onPressed: () async {
                  /*
                  User? user;
                  user =
                      await Authentication.signInWithGoogle(context: context);
                  print(user);
                  if (user != null) {
                    print(user.displayName);
                    print(user.email);
                    print(user.emailVerified);
                    print(user.phoneNumber);
                  }
                  */
                  user.authMethod = AuthenticationMethod.google;
                  await user.loadUser();
                },
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: SignInButton(
                Buttons.Facebook,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                text: "Iniciar sesión\ncon Facebook",
                onPressed: () async {
                  user.authMethod = AuthenticationMethod.facebook;
                  await user.loadUser();
                },
              ),
            ),
            // Mensajes de inicio de sesión
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: const Session(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Clase para procesar la sesión
class Session extends StatelessWidget {
  ///  Class Key
  const Session({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar usuario
    final user = context.watch<UserModel>();

    switch (user.userStatus) {
      case UserStatus.idle:
        return Container();
      case UserStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case UserStatus.unauthorized:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Error de credenciales\n',
                textAlign: TextAlign.center,
              ),
              Text(
                'Revise usuario y contraseña \n'
                'e intente nuevamente.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      case UserStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Error de ingreso\n',
                textAlign: TextAlign.center,
              ),
              Text(
                'Intente de nuevo más tarde o \n'
                'contacte al administrador del sitio.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      case UserStatus.loaded:
        // Pequeño delay
        _waitAndMove(context);
        user.userStatus = UserStatus.idle;
        return const Center(child: Text('Cargando página inicial...'));
    }
  }
}

// Método para pasar a la siguiente página tras un delay
Future _waitAndMove(BuildContext context) async {
  await Future<void>.delayed(const Duration(milliseconds: 800));
  await Navigator.pushNamed(context, '/home');
}
