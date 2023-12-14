import 'dart:convert';
import 'package:frontend2/class/servicios.class.dart';
import 'package:http/http.dart' as http;

class ConnectionServices {
  final String _baseUrl = 'http://10.0.2.2:3000/api/servicios';

  Future<List<Servicios>> getServicios() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> serviciosJson = json.decode(response.body);
      return serviciosJson.map((json) => Servicios.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los servicios: ${response.statusCode}');
    }
  }

  Future<bool> createServicio(Servicios servicio) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(servicio.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el servicio');
    }
    bool success = true; // o false, dependiendo del resultado de la operación

    return success;
  }

  Future<void> updateServicio(int idServicio, Servicios servicio) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$idServicio'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(servicio.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el servicio');
    }
  }

  Future<void> deleteServicio(int idServicio) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$idServicio'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el servicio');
    }
  }

  Future<List<Servicios>> getServiciosByUserId(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/nose/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> serviciosJson = json.decode(response.body);
      return serviciosJson.map((json) => Servicios.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener los servicios del usuario: ${response.statusCode}');
    }
  }
}
