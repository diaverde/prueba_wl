/// Clase Album
class SpAlbum {
  SpAlbum({
    this.id,
    this.name,
    this.artistID,
    this.albumURL,
  });

  /// ID en Spotify
  String? id;

  /// Nombre
  String? name;

  /// Artista(s)
  List<String>? artistID;

  /// Enlace a detalles
  String? albumURL;

  factory SpAlbum.fromJson(Map<String, dynamic> json) => SpAlbum(
        id: json['id'] as String?,
        name: json['name'] as String?,
        artistID: (json['artists'] as List<dynamic>?)
            ?.map((e) => e['id'] as String)
            .toList(),
        albumURL: json['href'] as String?,
      );
}
