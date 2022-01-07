// -------------------------------------------------------------------
// -----------------Datos globales de configuración-------------------
// -------------------------------------------------------------------

import 'dart:convert';
import 'package:flutter/services.dart';

/// Clase para conexión a servicios
class Config {
  // Direcciones a cargar
  static Map<String, dynamic> _config = <String, dynamic>{};

  /// Cargar el archivo de configuración adecuado
  static const configFile = String.fromEnvironment('DEFINE_CONFIG_FILE',
      defaultValue: 'config/spotify_data.json');

  /// Inicializa la carga del archivo correspondiente
  static Future<void> initialize() async {
    final configString = await rootBundle.loadString(configFile);
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  /// Avatar por defecto de usuarios
  static String get defaultAvatar => 'images/default-welcomer.png';

  /// Datos de ingreso por defecto
  static String get defaultLoginData =>
      '{"data":{"nombreUsuario":"odraude1362@gmail.com","clave":"Jorgito123"}}';

  /// URL para login
  static String get userLoginURL =>
      'https://apim3w.com/api/index.php/v1/soap/LoginUsuario.json';

  /// URL para obtener token de Spotify
  static String get spotifyTokenURL => 'https://accounts.spotify.com/api/token';

  /// URL de API de Spotify
  static String spotifyEndpoint = 'https://api.spotify.com/v1/';

  /// URL para obtener categorías
  static String get categoriesURL => spotifyEndpoint + 'browse/categories';

  /// URL para obtener playlists
  static String get playlistsURL =>
      spotifyEndpoint + 'browse/categories/--/playlists';

  /// URL para obtener pistas
  static String get tracksURL => spotifyEndpoint + 'playlists/--/tracks';

  /// Datos para Spotify importados de archivo
  static String get clientId => _config['clientID'];
  static String get clientSecret => _config['clientSecret'];
}
