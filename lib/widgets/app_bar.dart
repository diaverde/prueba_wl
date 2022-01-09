import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prueba_wl/utils/config.dart';
import 'package:prueba_wl/provider/spotify.dart';
import 'package:prueba_wl/provider/user.dart';

/// Clase para mostrar AppBar
class ApplicationBar {
  /// AppBar
  // Recibe de parámetros el contexto actual y una bandera
  // que indica si al ir hacia atrás se estaría abandonando el módulo completo
  static PreferredSize appBar(BuildContext context,
      {bool leavingBlock = false}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: AppBar(
        title: const Text('Prueba WL'),
        leading: GestureDetector(
          onTap: () async {
            if (leavingBlock) {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar cierre de sesión'),
                  content: const Text('¿Cerrar sesión y retornar a la\n'
                      'pantalla inicial?'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        resetVariables(context);
                      },
                      child: const Text('Sí'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => Align(
                      alignment: const Alignment(0.5, -0.75),
                      child: SizedBox(
                        height: 200,
                        child: UserInfoCard.drawer(context),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clase para datos de usuario
class UserInfoCard {
  /// Datos de usuario
  static Widget drawer(BuildContext context) {
    // Capturar modelo de usuario de Provider
    final user = context.read<UserModel>();
    final fullName = ((user.currentUser.firstName ?? '') +
        (user.currentUser.lastName ?? 'Usuario nulo'));

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Image.asset(
                        Config.defaultAvatar,
                        width: 100,
                        height: 90,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$fullName\n',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Correo electrónico:\n${user.currentUser.userName}\n',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Documento:\n${user.currentUser.idNumber}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.blue),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar cierre de sesión'),
                        content: const Text(
                            '¿Cerrar sesión y retornar a la\npantalla inicial?'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('No'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).highlightColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              resetVariables(context);
                            },
                            child: const Text('Sí'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Método para reiniciar las variables claves al cerrar sesión
Future<void> resetVariables(BuildContext context) async {
  // Capturar usuario
  final user = context.read<UserModel>();
  // Capturar modelo de Spotify
  final spotify = context.read<SpotifyModel>();

  await Future<void>.delayed(const Duration(milliseconds: 500));

  // Limpiar todos los Provider
  user.resetAll();
  spotify.resetAll();
}
