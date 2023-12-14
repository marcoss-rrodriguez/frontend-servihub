import 'dart:convert';
import 'dart:io';
import 'package:frontend2/class/fotos.class.dart';
import 'package:http/http.dart' as http;

class ConnectionFotos {
  final String _baseUrl = 'http://10.0.2.2:3000/api/foto';

  Future<List<Fotos>> getFotos() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> fotosJson = json.decode(response.body);
      return fotosJson.map((json) => Fotos.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las fotos: ${response.statusCode}');
    }
  }

  Future<Fotos> getFotoById(int idFoto) async {
    final response = await http.get(Uri.parse('$_baseUrl/$idFoto'));
    if (response.statusCode == 200) {
      return Fotos.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener la foto: ${response.statusCode}');
    }
  }

  Future<int> subirFoto(File imagen) async {
    int idReferencia = 1;
    final uri = Uri.parse('$_baseUrl');
    final request = http.MultipartRequest('POST', uri)
      ..fields['id_referencia'] = idReferencia.toString()
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        await imagen.readAsBytes(),
        filename: imagen.path.split("/").last,
      ));
    final response = await request.send();
    if (response.statusCode == 201) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final fotoId = json.decode(responseString)['id_foto'];
      return fotoId; // El ID de la foto subida
    } else {
      throw Exception('Error al subir la foto: ${response.statusCode}');
    }
  }

  Future<bool> actualizarFoto(int idFoto, File nuevaImagen) async {
    final uri = Uri.parse('$_baseUrl/$idFoto');
    final request = http.MultipartRequest('PUT', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        await nuevaImagen.readAsBytes(),
        filename: nuevaImagen.path.split("/").last,
      ));
    final response = await request.send();
    if (response.statusCode == 200) {
      return true; // La foto se actualizó con éxito
    } else {
      throw Exception('Error al actualizar la foto: ${response.statusCode}');
    }
  }
}
