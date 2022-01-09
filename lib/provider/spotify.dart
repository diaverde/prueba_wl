// ----------------------------------------------------
// ------Modelo de Datos de Spotify para Provider------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:prueba_wl/utils/config.dart';
import 'package:prueba_wl/models/album.dart';
import 'package:prueba_wl/models/artist.dart';
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

  /// Lista de filtros de búsqueda
  final Map<String, String> searchTypes = {
    'Álbum': 'album',
    'Artista': 'artist',
    'Playlist': 'playlist',
    'Canción': 'track',
  };

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

  // Nombre de artista seleccionado
  String selectedArtistName = '';

  // Filtro de búsqueda seleccionado
  String selectedSearchType = '';

  // Texto de búsqueda ingresado
  String searchText = '';

  /// Estado actual de búsqueda
  LoadStatus searchStatus = LoadStatus.idle;

  // Artista seleccionado
  SpArtist selectedArtist = SpArtist(genres: [], images: []);

  /// Lista de categorías cargadas
  List<SpCategory> listOfCategories = <SpCategory>[];

  /// Lista de playlists
  List<SpPlaylist> listOfPlaylists = <SpPlaylist>[];

  /// Lista de canciones (de playlist)
  List<SpTrack> listOfTracks = <SpTrack>[];

  /// Lista de álbumes de un artista
  List<SpAlbum> listOfAlbums = <SpAlbum>[];

  /// Lista de canciones populares (de artista)
  List<SpTrack> listOfTopTracks = <SpTrack>[];

  /// Lista de nuevos lanzamients
  List<SpAlbum> listOfNewReleases = <SpAlbum>[];

  /// Lista de resultados de búsqueda
  List<dynamic> listOfSearchResults = [];

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    spToken = '';
    sessionStatus = LoadStatus.idle;
    selectedCountry = '';
    selectedCategory = '';
    selectedPlaylist = '';
    selectedSearchType = '';
    selectedArtistName = '';
    searchText = '';
    selectedArtist = SpArtist(genres: [], images: []);
    listOfCategories.clear();
    listOfPlaylists.clear();
    listOfTracks.clear();
    listOfAlbums.clear();
    listOfTopTracks.clear();
    listOfNewReleases.clear();
    listOfSearchResults.clear();
    notifyListeners();
  }

  void setNewArtistName(String name) {
    selectedArtistName = name;
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
      //print(response.body);

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
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    try {
      final response = await http.get(
          Uri.parse('${Config.categoriesURL}?country=$country'),
          headers: headers);
      //print(response.body);

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
      //print(response.body);

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
      //print(response.body);

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

  /// Función para obtener detalles de un artista
  Future<bool> getArtist(String artistID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    final _fixedURL = '${Config.artistURL}/$artistID';
    try {
      final response = await http.get(Uri.parse(_fixedURL), headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        selectedArtist = SpArtist.fromJson(temp);
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

  /// Función para obtener álbumes de un artista
  Future<bool> getAlbums(String artistID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    final _fixedURL = Config.albumsURL.replaceAll('--', artistID);
    try {
      final response = await http.get(Uri.parse(_fixedURL), headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['items'];
        listOfAlbums.clear();
        for (final item in myList) {
          listOfAlbums.add(SpAlbum.fromJson(item));
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

  /// Función para obtener pistas populares de un artista
  Future<bool> getTopTracks(String artistID, String country) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    final _fixedURL =
        '${Config.topTracksURL.replaceAll('--', artistID)}?market=$country';
    try {
      final response = await http.get(Uri.parse(_fixedURL), headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['tracks'];
        listOfTopTracks.clear();
        for (final item in myList) {
          listOfTopTracks.add(SpTrack.fromJson(item));
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

  /// Función para obtener últimos lanzamientos
  Future<bool> getNewReleases(String country) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    try {
      final response = await http.get(
          Uri.parse('${Config.newReleasesURL}?country=$country'),
          headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['albums']['items'];
        listOfNewReleases.clear();
        for (final item in myList) {
          listOfNewReleases.add(SpAlbum.fromJson(item));
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

  /// Carga de resultados por búsqueda en Spotify
  Future<void> loadSearchResults(String type, String query) async {
    searchStatus = LoadStatus.loading;
    notifyListeners();
    final futureResult = await getSearchResults(type, query);
    if (futureResult) {
      searchStatus = LoadStatus.loaded;
    } else {
      searchStatus = LoadStatus.error;
    }
    notifyListeners();
  }

  /// Función para realizar búsquedas
  Future<bool> getSearchResults(String type, String query) async {
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + spToken
    };
    try {
      final response = await http.get(
          Uri.parse('${Config.searchURL}?type=$type&q=$query'),
          headers: headers);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        listOfSearchResults.clear();
        switch (type) {
          case 'album':
            final myList = temp['albums']['items'];
            for (final item in myList) {
              listOfSearchResults.add(SpAlbum.fromJson(item));
            }
            break;
          case 'artist':
            final myList = temp['artists']['items'];
            for (final item in myList) {
              listOfSearchResults.add(SpArtist.fromJson(item));
            }
            break;
          case 'playlist':
            final myList = temp['playlists']['items'];
            for (final item in myList) {
              listOfSearchResults.add(SpPlaylist.fromJson(item));
            }
            break;
          case 'track':
            final myList = temp['tracks']['items'];
            for (final item in myList) {
              listOfSearchResults.add(SpTrack.fromJson(item));
            }
            break;
        }
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
