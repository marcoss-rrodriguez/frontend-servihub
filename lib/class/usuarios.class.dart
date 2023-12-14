import 'package:frontend2/class/fotos.class.dart';
import 'package:frontend2/connection/connection.foto.dart';

class Usuarios {
  int? id_usuario;
  String nombre;
  String apellido;
  String nombreUsuario;
  int idTipoUsuario;
  String email;
  String contrasena;
  DateTime fechaNacimiento;
  String sexo;
  int puntuacionVendedor;
  int puntuacionComprador;
  String descripcionPerfil;
  int? idFotoPerfil;
  String horariosAtencion;

  Usuarios({
    this.id_usuario,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
    required this.idTipoUsuario,
    required this.email,
    required this.contrasena,
    required this.fechaNacimiento,
    required this.sexo,
    required this.puntuacionVendedor,
    required this.puntuacionComprador,
    required this.descripcionPerfil,
    this.idFotoPerfil,
    required this.horariosAtencion,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) => Usuarios(
        id_usuario: json["id_usuario"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        nombreUsuario: json["nombre_usuario"],
        idTipoUsuario: json["id_tipo_usuario"],
        email: json["email"],
        contrasena: json["contraseña"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        sexo: json["sexo"],
        puntuacionVendedor: json["puntuacion_vendedor"],
        puntuacionComprador: json["puntuacion_comprador"],
        descripcionPerfil: json["descripcion_perfil"],
        idFotoPerfil: json["id_foto_perfil"],
        horariosAtencion: json["horarios_atencion"],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario": id_usuario,
        "nombre": nombre,
        "apellido": apellido,
        "nombre_usuario": nombreUsuario,
        "id_tipo_usuario": idTipoUsuario,
        "email": email,
        "contraseña": contrasena,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "sexo": sexo,
        "puntuacion_vendedor": puntuacionVendedor,
        "puntuacion_comprador": puntuacionComprador,
        "descripcion_perfil": descripcionPerfil,
        "id_foto_perfil": idFotoPerfil,
        "horarios_atencion": horariosAtencion,
      };

  Future<String> getUrlFotoPerfil() async {
    if (idFotoPerfil != null) {
      ConnectionFotos connectionFotos = ConnectionFotos();
      Fotos foto = await connectionFotos.getFotoById(idFotoPerfil!);
      return foto.ubicacionFoto;
    } else {
      return 'URL por defecto o manejo de error'; // Retorna una URL por defecto o maneja el caso de que no haya foto
    }
  }
}
