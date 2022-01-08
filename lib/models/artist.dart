/// Clase Artist
class SpArtist {
  SpArtist({
    this.id,
    this.name,
    this.followers,
    this.genres,
    this.images,
    this.artistURL,
  });

  /// ID en Spotify
  String? id;

  /// Nombre
  String? name;

  /// Seguidores
  int? followers;

  /// Géneros
  List<String>? genres;

  // Imágenes
  List<String>? images;

  /// Enlace a detalles
  String? artistURL;

  factory SpArtist.fromJson(Map<String, dynamic> json) => SpArtist(
        id: json['id'] as String?,
        name: json['name'] as String?,
        followers: json['followers']['total'] as int?,
        genres: (json['genres'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => e['url'] as String)
            .toList(),
        artistURL: json['href'] as String?,
      );
}
