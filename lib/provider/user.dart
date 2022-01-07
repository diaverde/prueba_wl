// ----------------------------------------------------
// ---------Modelo de Usuario para Provider------------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:prueba_wl/config.dart';
import 'package:prueba_wl/models/user.dart';

/// Estados del usuario (en login)
enum UserStatus {
  /// En espera
  idle,

  /// Cargando
  loading,

  /// Cargado
  loaded,

  /// Error genérico
  error
}

/// Modelo para el usuario
class UserModel extends ChangeNotifier {
  /// Usuario de login
  String loginUserName = '';

  /// Contraseña de login
  String loginPassword = '';

  /// Información del usuario actual en sesión
  User currentUser = User();

  /// Estado actual de carga de usuario
  UserStatus userStatus = UserStatus.idle;

  /// Token de Spotify
  String spToken = '';

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    loginUserName = '';
    loginPassword = '';
    currentUser = User();
    userStatus = UserStatus.idle;
    spToken = '';
    notifyListeners();
  }

  /// Carga de usuario al iniciar sesión
  Future<void> loadUser(String userInfo) async {
    userStatus = UserStatus.loading;
    notifyListeners();
    final futureUserResult = await fetchUser(userInfo);
    if (futureUserResult == 'Usuario cargado') {
      userStatus = UserStatus.loaded;
    } else {
      userStatus = UserStatus.error;
    }
    notifyListeners();
  }

  /// Función para hacer petición POST y obtener datos del usuario
  Future<String> fetchUser(String userInfo) async {
    // Reemplazar por los datos genéricos indicados en el ejercicio
    userInfo = Config.defaultLoginData;
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'X-MC-SO': 'WigilabsTest'
    };
    try {
      final response = await http.post(Uri.parse(Config.userLoginURL),
          body: userInfo, headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        if (temp is Map<String, dynamic> &&
            temp['error'] == 0 &&
            temp['response'] != null) {
          currentUser = User.fromJson(temp['response']['usuario']);
          return 'Usuario cargado';
        } else {
          return 'Error obteniendo datos de usuario';
        }
      } else {
        return 'Error obteniendo datos de usuario';
      }
    } on Exception catch (e) {
      //print(e);
      return 'Excepción: $e';
    }
  }
}
