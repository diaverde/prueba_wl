// ----------------------------------------------------
// ------Modelo de Datos de Spotify para Provider------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:prueba_wl/config.dart';
import 'package:prueba_wl/models/category.dart';
import 'package:prueba_wl/models/playlist.dart';
import 'package:prueba_wl/models/track.dart';

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
  /// Lista de países a considerar
  final List<String> countries = ['Colombia', 'Australia'];

  /// Token de Spotify
  String spToken = '';

  /// Estado actual de sesión de Spotify
  LoadStatus sessionStatus = LoadStatus.idle;

  // País seleccionado actualmente
  String selectedCountry = '';

  // Categoría seleccionada
  String selectedCategory = '';

  // Lista de reproducción seleccionada
  String selectedPlaylist = '';

  /// Lista de categorías cargadas
  List<SpCategory> listOfCategories = <SpCategory>[
    SpCategory(id: 'rock', name: 'Rock'),
    SpCategory(id: 'rap', name: 'Rap'),
    SpCategory(id: 'salsa', name: 'Salsa'),
  ];

  /// Lista de playlists
  List<SpPlaylist> listOfPlaylists = <SpPlaylist>[
    SpPlaylist(
        id: '1',
        name: 'darkie',
        description: 'Oscura',
        numberOfTracks: 3,
        tracksURL: '#'),
    SpPlaylist(
        id: '2',
        name: 'punkie',
        description: 'Lo mejor del punk',
        numberOfTracks: 6,
        tracksURL: '#'),
    SpPlaylist(
        id: '3',
        name: 'oldie',
        description: 'Viejos clásicos',
        numberOfTracks: 7,
        tracksURL: '#'),
  ];

  /// Lista de canciones
  List<SpTrack> listOfTracks = <SpTrack>[
    SpTrack(
        id: '1',
        name: 'Doom',
        albumID: '1',
        album: '1994',
        artistID: ['1'],
        artist: ['Damn'],
        trackURL: '#'),
    SpTrack(
        id: '2',
        name: 'Ding',
        albumID: '1',
        album: '1994',
        artistID: ['1', '4'],
        artist: ['Damn', 'Dirnt'],
        trackURL: '#'),
    SpTrack(
        id: '3',
        name: 'Blank Space',
        albumID: '2',
        album: 'Boosting 1994',
        artistID: ['2'],
        artist: ['Taylor'],
        trackURL: '#'),
  ];

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    spToken = '';
    sessionStatus = LoadStatus.idle;
    selectedCountry = '';
    selectedCategory = '';
    selectedPlaylist = '';
    listOfCategories.clear();
    listOfPlaylists.clear();
    listOfTracks.clear();
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

  /// Función para obtener categorías
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

  /// Función para obtener listas de reproducción
  Future<bool> getPlaylists(String country, String categoryID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    final _fixedURL =
        '${Config.playlistsURL.replaceAll('--', categoryID)}?country=$country';
    try {
      final response = await http.get(Uri.parse(_fixedURL), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['playlists']['items'];
        listOfPlaylists.clear();
        for (final item in myList) {
          listOfPlaylists.add(SpPlaylist.fromJson(item));
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

  /// Función para obtener pistas de una lista de reproducción
  Future<bool> getTracks(String playlistID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    final _fixedURL = Config.tracksURL.replaceAll('--', playlistID);
    try {
      final response = await http.get(Uri.parse(_fixedURL), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['items'];
        listOfTracks.clear();
        for (final item in myList) {
          listOfTracks.add(SpTrack.fromJson(item['track']));
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
