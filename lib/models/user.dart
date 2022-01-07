/// Clase User
class User {
  /// Constructor
  User({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.idNumber,
  });

  /// ID en base de datos
  String? id;

  /// Nombre virtual de usuario
  String? userName;

  /// Nombre del usuario
  String? firstName;

  /// Apellido del usuario
  String? lastName;

  /// Documento de identidad
  String? idNumber;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['UID'] as String?,
        userName: json['UserProfileID'] as String?,
        firstName: json['nombre'] as String?,
        lastName: json['apellido'] as String?,
        idNumber: json['DocumentNumber'] as String?,
      );
}
