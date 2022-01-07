/// Clase Artist
class SpArtist {
  SpArtist({
    this.id,
    this.name,
    this.artistURL,
  });

  /// ID en Spotify
  String? id;

  /// Nombre
  String? name;

  /// Enlace a detalles
  String? artistURL;

  factory SpArtist.fromJson(Map<String, dynamic> json) => SpArtist(
        id: json['id'] as String?,
        name: json['name'] as String?,
        artistURL: json['href'] as String?,
      );
}
