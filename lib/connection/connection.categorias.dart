import 'dart:convert';
import 'package:frontend2/class/categorias.class.dart';
import 'package:http/http.dart' as http;

class ConnectionCategorias {
  final String _baseUrl = 'http://10.0.2.2:3000/api/categoria_servicios';

  Future<List<Categorias>> getCategorias() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> categoriasJson = json.decode(response.body);
      return categoriasJson.map((json) => Categorias.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener las categorías: ${response.statusCode}');
    }
  }

  Future<bool> createCategoria(Categorias categoria) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<void> updateCategoria(int idCategoria, Categorias categoria) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$idCategoria'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la categoría');
    }
  }

  Future<void> deleteCategoria(int idCategoria) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$idCategoria'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la categoría');
    }
  }
}
