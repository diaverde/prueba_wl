// -------------------------------------------------------------------
// -----------------Datos globales de configuración-------------------
// -------------------------------------------------------------------

/// Clase para conexión a servicios
class Config {
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

  /// Datos para Spotify
  static String get clientId => 'f08343dbd3d04379a847c89a6a4ea391';
  static String get clientSecret => 'a7e528e03d2d49eb9b4534fcd56e39ba';
}
