/// Clase Playlist
class SpPlaylist {
  SpPlaylist({
    this.id,
    this.name,
    this.description,
    this.numberOfTracks,
    this.tracksURL,
  });

  /// ID en API
  String? id;

  /// Nombre
  String? name;

  /// Descripción
  String? description;

  /// Número de pistas
  int? numberOfTracks;

  /// Enlace a lista de canciones
  String? tracksURL;

  factory SpPlaylist.fromJson(Map<String, dynamic> json) => SpPlaylist(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        numberOfTracks: json['tracks']['total'] as int?,
        tracksURL: json['tracks']['href'] as String?,
      );
}
