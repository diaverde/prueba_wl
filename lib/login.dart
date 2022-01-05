// ---------------------------------------------------------------------
// -----------------------------Inicio----------------------------------
// ---------------------------------------------------------------------

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Clase principal
class LoginPage extends StatelessWidget {
  ///  Class Key
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Inicio de sesión'),
        ),
        body: LoginPageDetails(),
      );
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
                        //user.userName = value.toLowerCase().trim();
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
                    child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contraseña',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[\n\t\r]'))
                      ],
                      onChanged: (value) {
                        //user.password = value;
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
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).highlightColor,
                  ),
                  onPressed: () async {
                    // Validar
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      //print(jsonEncode(loginUser));
                      //await user.loadUser(jsonEncode(loginUser));
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
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: const Text(
                'O utilice sus credenciales:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: SignInButton(
                Buttons.Google,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                text: "Iniciar sesión con Google",
                onPressed: () {},
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: SignInButton(
                Buttons.Facebook,
                padding: const EdgeInsets.all(20),
                text: "Iniciar sesión con Facebook",
                onPressed: () {},
              ),
            ),
            // Mensajes de inicio de sesión
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }
}
