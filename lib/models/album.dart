/// Clase Album
class SpAlbum {
  SpAlbum({
    this.id,
    this.name,
    this.artistID,
    this.artist,
    this.releaseDate,
    this.totalTracks,
    this.albumURL,
  });

  /// ID en Spotify
  String? id;

  /// Nombre
  String? name;

  /// Artista(s) (ID)
  List<String>? artistID;

  /// Artista(s)
  List<String>? artist;

  /// Fecha de lanzamiento
  String? releaseDate;

  /// Total de canciones
  int? totalTracks;

  /// Enlace a detalles
  String? albumURL;

  factory SpAlbum.fromJson(Map<String, dynamic> json) => SpAlbum(
        id: json['id'] as String?,
        name: json['name'] as String?,
        artistID: (json['artists'] as List<dynamic>?)
            ?.map((e) => e['id'] as String)
            .toList(),
        artist: (json['artists'] as List<dynamic>?)
            ?.map((e) => e['name'] as String)
            .toList(),
        releaseDate: json['release_date'] as String?,
        totalTracks: json['total_tracks'] as int?,
        albumURL: json['href'] as String?,
      );
}
