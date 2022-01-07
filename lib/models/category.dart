/// Clase Category
class SpCategory {
  SpCategory({
    this.id,
    this.name,
  });

  /// ID en API
  String? id;

  /// Nombre
  String? name;

  factory SpCategory.fromJson(Map<String, dynamic> json) => SpCategory(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );
}
