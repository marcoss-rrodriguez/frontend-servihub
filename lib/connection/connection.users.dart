import 'dart:convert';
import 'package:frontend2/class/usuarios.class.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Connection {
  final String _baseUrl = 'http://10.0.2.2:3000/api/usuarios';

  Future<List<Usuarios>> getUsuarios() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> usuariosJson = json.decode(response.body);
      return usuariosJson.map((json) => Usuarios.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los usuarios: ${response.statusCode}');
    }
  }

  Future<bool> createUsuario(Usuarios usuario) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el usuario');
    }
    bool success = true; // o false, dependiendo del resultado de la operación

    return success;
  }

  Future<void> updateUsuario(int idUsuario, Usuarios usuario) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$idUsuario'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el usuario');
    }
  }

  Future<void> deleteUsuario(int idUsuario) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$idUsuario'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  Future<Map<String, dynamic>> verifyCredentials(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre_usuario': username,
          'contraseña': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Asegúrate de que el token JWT esté presente en la respuesta
        if (data['token'] != null) {
          // Guarda el token JWT usando shared_preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data['token']);
          // Agrega el id_usuario si está presente en la respuesta
          if (data['id_usuario'] != null) {
            await prefs.setInt('id_usuario', data['id_usuario']);
          }
          return {
            'success': true,
            'token': data['token'],
            'id_usuario': data['id_usuario']
          };
        } else {
          print('Error: El token JWT no está presente en la respuesta');
          return {
            'success': false,
            'message': 'El token JWT no está presente en la respuesta'
          };
        }
      } else if (response.statusCode == 401) {
        // Credenciales no autorizadas
        return {'success': false, 'message': 'Credenciales no autorizadas'};
      } else {
        // Maneja otros códigos de estado HTTP
        return {
          'success': false,
          'message': 'Error con el código de estado: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al verificar las credenciales: $e');
      return {
        'success': false,
        'message': 'Error al verificar las credenciales: $e'
      };
    }
  }

  Future<Usuarios> getUsuarioById(int idUsuario) async {
    final response = await http.get(Uri.parse('$_baseUrl/$idUsuario'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> usuarioJson = json.decode(response.body);
      return Usuarios.fromJson(usuarioJson);
    } else {
      throw Exception('Error al obtener el usuario: ${response.statusCode}');
    }
  }
}
