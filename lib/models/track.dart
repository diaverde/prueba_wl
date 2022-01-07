/// Clase Track
class SpTrack {
  SpTrack(
      {this.id,
      this.name,
      this.albumID,
      this.album,
      this.artistID,
      this.artist,
      this.trackURL});

  /// ID en Spotify
  String? id;

  /// Nombre
  String? name;

  /// Álbum (ID)
  String? albumID;

  /// Álbum
  String? album;

  /// Artista(s) (ID)
  List<String>? artistID;

  /// Artista(s)
  List<String>? artist;

  /// Enlace a detalles
  String? trackURL;

  factory SpTrack.fromJson(Map<String, dynamic> json) => SpTrack(
        id: json['id'] as String?,
        name: json['name'] as String?,
        albumID: json['album']['id'] as String?,
        album: json['album']['name'] as String?,
        artistID: (json['artists'] as List<dynamic>?)
            ?.map((e) => e['id'] as String)
            .toList(),
        artist: (json['artists'] as List<dynamic>?)
            ?.map((e) => e['name'] as String)
            .toList(),
        trackURL: json['href'] as String?,
      );
}
