import 'dart:convert';
import 'package:frontend2/class/contrataciones.class.dart';
import 'package:http/http.dart' as http;

class ConnectionContrataciones {
  final String _baseUrl = 'http://10.0.2.2:3000/api/contrataciones';

  Future<List<Contrataciones>> getContrataciones() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> contratacionesJson = json.decode(response.body);
      return contratacionesJson
          .map((json) => Contrataciones.fromJson(json))
          .toList();
    } else {
      throw Exception(
          'Error al obtener las contrataciones: ${response.statusCode}');
    }
  }

  Future<Contrataciones> getContratacionById(int idContratacion) async {
    final response = await http.get(Uri.parse('$_baseUrl/$idContratacion'));
    if (response.statusCode == 200) {
      return Contrataciones.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Error al obtener la contratación: ${response.statusCode}');
    }
  }

  Future<Contrataciones> crearContratacion(Contrataciones contratacion) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contratacion.toJson()),
    );
    if (response.statusCode == 200) {
      return Contrataciones.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Error al añadir la contratación: ${response.statusCode}');
    }
  }

  Future<bool> borrarContratacion(int idContratacion) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$idContratacion'));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Error al borrar la contratación: ${response.statusCode}');
    }
  }

  Future<bool> actualizarContratacion(
      int idContratacion, Contrataciones contratacion) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$idContratacion'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contratacion.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Error al actualizar la contratación: ${response.statusCode}');
    }
  }
}
