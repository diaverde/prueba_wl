// ----------------------------------------------------
// ---------Modelo de Usuario para Provider------------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_wl/utils/authentication.dart';

import 'package:prueba_wl/utils/config.dart';
import 'package:prueba_wl/models/user.dart';

/// Estados del usuario (en login)
enum UserStatus {
  /// En espera
  idle,

  /// Cargando
  loading,

  /// Cargado
  loaded,

  /// No autorizado
  unauthorized,

  /// Error genérico
  error
}

/// Método de ingreso utilizado
enum AuthenticationMethod {
  /// Estándar
  standard,

  /// Google
  google,

  /// Facebook
  facebook
}

/// Modelo para el usuario
class UserModel extends ChangeNotifier {
  /// Usuario de login
  String loginUserName = '';

  /// Contraseña de login
  String loginPassword = '';

  /// Información del usuario actual en sesión
  AppUser currentUser = AppUser();

  /// Estado actual de carga de usuario
  UserStatus userStatus = UserStatus.idle;

  /// Método de autenticación elegido
  AuthenticationMethod authMethod = AuthenticationMethod.standard;

  /// Token de Spotify
  String spToken = '';

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    loginUserName = '';
    loginPassword = '';
    currentUser = AppUser();
    userStatus = UserStatus.idle;
    authMethod = AuthenticationMethod.standard;
    spToken = '';
    notifyListeners();
  }

  /// Carga de usuario al iniciar sesión
  Future<void> loadUser() async {
    userStatus = UserStatus.loading;
    notifyListeners();
    bool? result;
    switch (authMethod) {
      case AuthenticationMethod.standard:
        result = await Authentication.logInToFb(loginUserName, loginPassword);
        break;
      case AuthenticationMethod.google:
        final resultG = await Authentication.signInWithGoogle();
        if (resultG == 'Ok') {
          result = true;
        }
        break;
      case AuthenticationMethod.facebook:
        final resultG = await Authentication.signInWithFacebook();
        if (resultG != null) {
          result = true;
        }
        break;
    }
    //print(userLoginData);
    if (result != null) {
      if (result) {
        final userLoginData = '"data": {'
            '"nombreUsuario": "$loginUserName",'
            '"clave": "$loginPassword",'
            '}}';
        final futureUserResult = await fetchUser(userLoginData);
        if (futureUserResult == 'Usuario cargado') {
          userStatus = UserStatus.loaded;
        } else {
          userStatus = UserStatus.error;
        }
      } else {
        userStatus = UserStatus.unauthorized;
      }
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
          currentUser = AppUser.fromJson(temp['response']['usuario']);
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
