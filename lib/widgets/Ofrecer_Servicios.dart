import 'dart:io';
import 'package:frontend2/connection/connection.foto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend2/class/servicios.class.dart';
import 'package:frontend2/class/usuarios.class.dart';
import 'package:frontend2/connection/connection.services.dart';
import 'package:frontend2/connection/connection.users.dart';
import 'package:frontend2/widgets/Principal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ofrecer_Servicio2 extends StatefulWidget {
  const Ofrecer_Servicio2({Key? key}) : super(key: key);

  @override
  _Ofrecer_Servicio2State createState() => _Ofrecer_Servicio2State();
}

class _Ofrecer_Servicio2State extends State<Ofrecer_Servicio2> {
  Usuarios? usuarioActual;
  String titulo = '';
  double precio = 0.0;
  String ubicacion = '';
  String descripcion = '';
  String tipoPrecio = 'Por Hora';

  List<String> tiposPrecio = ['Por Hora', 'Por Proyecto'];
  List<String> departamentosHonduras = [
    'Atlántida, Tela',
    'Atlántida, Arizona',
    'Atlántida, Esparta',
    'Atlántida, La Masica',
    'Atlántida, San Francisco',
    'Atlántida, El Porvenir',
    'Atlántida, La Ceiba',
    'Atlántida, Jutiapa',
  ];

  final List<String> _categoriasNombres = [
    'Albañilería',
    'Carpintería',
    'Pintura',
    'Reparación de Vehículos',
    'Cerrajería',
    'Albañil',
    'Mecánico',
    'Fontanería',
    'Soldador',
    'Sastre',
    'Escultor',
    'Barbero',
    'Niñero',
    'Cocinero',
    'Repartidor',
    'Exterminador',
    'Ebanista',
    'Electricista',
    'Cuidado de mascotas',
    'Agricultor',
    'Limpieza del hogar',
    'Lavandería',
    'Técnico en computación',
    'Pintura',
    'Cuidado de ancianos',
    'Organización de eventos',
    'Entrenador personal',
    'Masajista',
    'Asistente personal',
    'Costurero',
    'Reparación de electrodomésticos',
    'Servicios de mudanza'
  ];
  int _selectedCategoriaId = 1; // ID de la categoría seleccionada

  File? _imagenSeleccionada;

  Future<void> _seleccionarImagen(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Usa ImageSource.gallery para acceder a la galería del teléfono
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imagenSeleccionada = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuarioActual();
  }

  Future<void> _cargarUsuarioActual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('id_usuario');
    if (usuarioId == null) {
      print('Error: El ID del usuario no está disponible.');
      return;
    }
    Connection connectionUsuario = Connection();
    try {
      Usuarios usuario = await connectionUsuario.getUsuarioById(usuarioId);
      setState(() {
        usuarioActual = usuario;
      });
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  Future<void> _publicarServicio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('id_usuario');
    if (usuarioId == null) {
      mostrarError(context, 'Error: El ID del usuario no está disponible.');
      return;
    }
    if (_imagenSeleccionada == null) {
      mostrarError(
          context, 'Por favor, selecciona una imagen para el servicio.');
      return;
    }
    ConnectionFotos connectionFotos = ConnectionFotos();
    int idFotoServicio = await connectionFotos.subirFoto(_imagenSeleccionada!);
    Servicios nuevoServicio = Servicios(
      idServicio: null, // Se generará automáticamente en la base de datos
      idVendedor: usuarioId, // ID del usuario actual
      tituloServicio: titulo,
      ubicacionServicio: ubicacion,
      descripcionServicio: descripcion,
      precio: precio.toInt(),
      idCategoria: _selectedCategoriaId,
      idFotoServicio: idFotoServicio, // ID de la foto subida
    );
    ConnectionServices connectionServices = ConnectionServices();
    bool servicioCreado =
        await connectionServices.createServicio(nuevoServicio);
    if (servicioCreado) {
      mostrarExito(context, 'Servicio publicado con éxito.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    } else {
      mostrarError(context, 'Error al publicar el servicio.');
    }
  }

  // Funciones auxiliares para mostrar mensajes
  void mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void mostrarExito(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ubicacion.isEmpty && departamentosHonduras.isNotEmpty) {
      ubicacion = departamentosHonduras.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Servicio'),
        backgroundColor: const Color.fromARGB(255, 247, 42, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Título',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  titulo = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Ej. Reparo Automóviles',
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Precio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  precio = double.tryParse(value) ?? 0.0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ej. 500',
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tipo de Precio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: tipoPrecio,
              onChanged: (String? newValue) {
                setState(() {
                  tipoPrecio = newValue!;
                });
              },
              items: tiposPrecio.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: _selectedCategoriaId,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedCategoriaId = newValue!;
                });
              },
              items: List<DropdownMenuItem<int>>.generate(
                _categoriasNombres.length,
                (int index) => DropdownMenuItem<int>(
                  value: index + 1, // El ID de la categoría comienza en 1
                  child: Text(_categoriasNombres[index]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ubicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: ubicacion,
              onChanged: (String? newValue) {
                setState(() {
                  ubicacion = newValue!;
                });
              },
              items: departamentosHonduras
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(
              'Añadir Fotos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _seleccionarImagen(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _seleccionarImagen(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
              ],
            ),
            if (_imagenSeleccionada != null)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Image.file(
                  _imagenSeleccionada!,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  descripcion = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Describa detalladamente los servicios que ofrece',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _publicarServicio,
              child: const Text('Publicar Servicio'),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicioPublicadoExitosamente extends StatelessWidget {
  const ServicioPublicadoExitosamente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Éxito'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Servicio Publicado Exitosamente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Principal()),
                );
              },
              child: const Text('Volver a Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
