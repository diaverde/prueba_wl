// ----------------------------------------------------
// ------Modelo de Datos de Spotify para Provider------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:prueba_wl/config.dart';
import 'package:prueba_wl/models/category.dart';

/// Estados de carga
enum LoadStatus {
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
class SpotifyModel extends ChangeNotifier {
  /// Token de Spotify
  String spToken = '';

  /// Estado actual de sesión de Spotify
  LoadStatus sessionStatus = LoadStatus.idle;

  /// Lista de categorías cargadas
  List<SpCategory> listOfCategories = <SpCategory>[];

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    spToken = '';
    sessionStatus = LoadStatus.idle;
    listOfCategories.clear();
    notifyListeners();
  }

  /// Carga de sesión de Spotify
  Future<void> loadSession(String data) async {
    sessionStatus = LoadStatus.loading;
    notifyListeners();
    final futureResult = await retrieveToken();
    if (futureResult) {
      sessionStatus = LoadStatus.loaded;
    } else {
      sessionStatus = LoadStatus.error;
    }
    notifyListeners();
  }

  /// Función para hacer petición POST y obtener Token de sesión
  Future<bool> retrieveToken() async {
    final clientData = Config.clientId + ':' + Config.clientSecret;
    final bodyContent = {'grant_type': 'client_credentials'};
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Authorization': 'Basic ' + base64.encode(utf8.encode(clientData))
    };
    try {
      final response = await http.post(Uri.parse(Config.spotifyTokenURL),
          body: bodyContent, headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        spToken = temp['access_token'];
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      //print(e);
      return false;
    }
  }

  /// Función para hacer petición GET y obtener categorías
  Future<bool> getCategories(String country) async {
    print(spToken);
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    try {
      final response = await http.get(
          Uri.parse('${Config.categoriesURL}?country=$country'),
          headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['categories']['items'];
        listOfCategories.clear();
        for (final item in myList) {
          listOfCategories.add(SpCategory.fromJson(item));
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      //print(e);
      return false;
    }
  }
}
